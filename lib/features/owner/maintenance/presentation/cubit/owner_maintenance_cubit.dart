import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../../domain/usecases/get_owner_maintenance_use_case.dart';
import 'owner_maintenance_state.dart';

class OwnerMaintenanceCubit extends Cubit<OwnerMaintenanceState> {
  final GetOwnerMaintenanceUseCase _getMaintenanceUseCase;

  OwnerMaintenanceCubit(this._getMaintenanceUseCase)
      : super(const OwnerMaintenanceInitial());

  int _currentPage = 1;
  bool _isFetchingNext = false;
  String _currentStatus = 'all';

  String get currentStatus => _currentStatus;

  Future<void> getMaintenanceRequests({bool forceRefresh = false}) async {
    if (forceRefresh || state is! OwnerMaintenanceLoaded) {
      emit(OwnerMaintenanceLoading(activeStatus: _currentStatus));
    }
    _currentPage = 1;

    final result = await _getMaintenanceUseCase(
      GetOwnerMaintenanceParams(
        page: _currentPage,
        status: _currentStatus == 'all' ? null : _currentStatus,
        forceRefresh: forceRefresh,
      ),
    );

    result.fold(
      (failure) => emit(OwnerMaintenanceError(failure.message,
          activeStatus: _currentStatus)),
      (response) {
        if (response.items.isEmpty) {
          emit(OwnerMaintenanceEmpty(activeStatus: _currentStatus));
        } else {
          emit(OwnerMaintenanceLoaded(
            items: response.items,
            meta: response.meta,
            activeStatus: _currentStatus,
          ));
        }
      },
    );
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! OwnerMaintenanceLoaded ||
        _isFetchingNext ||
        !currentState.meta.hasMore) {
      return;
    }

    _isFetchingNext = true;
    emit(currentState.copyWith(isFetchingMore: true));

    _currentPage = currentState.meta.currentPage + 1;
    final result = await _getMaintenanceUseCase(
      GetOwnerMaintenanceParams(
        page: _currentPage,
        status: _currentStatus == 'all' ? null : _currentStatus,
        forceRefresh: false,
      ),
    );

    result.fold(
      (failure) {
        _isFetchingNext = false;
        emit(currentState.copyWith(isFetchingMore: false));
      },
      (response) {
        _isFetchingNext = false;
        final updatedList = List<MaintenanceItemEntity>.from(currentState.items)
          ..addAll(response.items);

        emit(OwnerMaintenanceLoaded(
          items: updatedList,
          meta: response.meta,
          activeStatus: _currentStatus,
        ));
      },
    );
  }

  void changeStatusFilter(String newStatus, {bool force = false}) {
    if (!force && _currentStatus == newStatus) return;
    _currentStatus = newStatus;
    getMaintenanceRequests(forceRefresh: true);
  }
}
