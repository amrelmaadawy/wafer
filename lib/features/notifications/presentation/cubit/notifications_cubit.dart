import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification_item_entity.dart';
import '../../domain/usecases/get_notifications_use_case.dart';
import 'notifications_state.dart';
import 'unread_count_cubit.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final UnreadCountCubit? _unreadCountCubit;

  NotificationsCubit(this._getNotificationsUseCase, [this._unreadCountCubit])
      : super(const NotificationsInitial());

  int _currentPage = 1;
  bool _isFetchingNext = false;
  String _currentFilter = 'all';

  Future<void> getNotifications({bool forceRefresh = false}) async {
    if (forceRefresh || state is! NotificationsLoaded) {
      emit(const NotificationsLoading());
    }
    _currentPage = 1;

    final result = await _getNotificationsUseCase(
      GetNotificationsParams(page: _currentPage, forceRefresh: forceRefresh),
    );

    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (response) {
        _unreadCountCubit?.updateCount(response.unreadCount);
        if (response.notifications.isEmpty) {
          emit(NotificationsEmpty(activeFilter: _currentFilter));
        } else {
          emit(NotificationsLoaded(
            notifications: response.notifications,
            meta: response.meta,
            unreadCount: response.unreadCount,
            activeFilter: _currentFilter,
          ));
        }
      },
    );
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! NotificationsLoaded || _isFetchingNext || !currentState.meta.hasMore) {
      return;
    }

    _isFetchingNext = true;
    emit(currentState.copyWith(isFetchingMore: true));

    _currentPage = currentState.meta.currentPage + 1;
    final result = await _getNotificationsUseCase(
      GetNotificationsParams(page: _currentPage, forceRefresh: false),
    );

    result.fold(
      (failure) {
        _isFetchingNext = false;
        emit(currentState.copyWith(isFetchingMore: false));
      },
      (response) {
        _isFetchingNext = false;
        _unreadCountCubit?.updateCount(response.unreadCount);
        final updatedList = List<NotificationItemEntity>.from(currentState.notifications)
          ..addAll(response.notifications);

        emit(NotificationsLoaded(
          notifications: updatedList,
          meta: response.meta,
          unreadCount: response.unreadCount,
          activeFilter: _currentFilter,
        ));
      },
    );
  }

  void changeFilter(String newFilter) {
    if (_currentFilter == newFilter) return;
    _currentFilter = newFilter;

    final currentState = state;
    if (currentState is NotificationsLoaded) {
      if (currentState.filteredNotifications.isEmpty) {
        emit(NotificationsEmpty(activeFilter: _currentFilter));
      } else {
        emit(currentState.copyWith(activeFilter: _currentFilter));
      }
    } else if (currentState is NotificationsEmpty) {
      getNotifications(forceRefresh: false);
    }
  }

  void markAllAsReadLocal() {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      final updated = currentState.notifications.map((n) {
        return NotificationItemEntity(
          id: n.id,
          title: n.title,
          body: n.body,
          type: n.type,
          readAt: DateTime.now().toIso8601String(),
          createdAt: n.createdAt,
          data: n.data,
        );
      }).toList();

      _unreadCountCubit?.resetCount();

      emit(currentState.copyWith(
        notifications: updated,
        unreadCount: 0,
      ));
    }
  }
}
