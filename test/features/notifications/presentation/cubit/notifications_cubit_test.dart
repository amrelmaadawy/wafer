import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/error/failures.dart';
import 'package:wafer/core/usecases/usecase.dart';
import 'package:wafer/features/notifications/domain/entities/notification_item_entity.dart';
import 'package:wafer/features/notifications/domain/entities/notification_pagination_meta_entity.dart';
import 'package:wafer/features/notifications/domain/entities/notifications_response_entity.dart';
import 'package:wafer/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:wafer/features/notifications/domain/usecases/get_notifications_use_case.dart';
import 'package:wafer/features/notifications/domain/usecases/mark_all_notifications_read_use_case.dart';
import 'package:wafer/features/notifications/domain/usecases/mark_notification_read_use_case.dart';
import 'package:wafer/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:wafer/features/notifications/presentation/cubit/notifications_state.dart';

class FakeGetNotificationsUseCase implements GetNotificationsUseCase {
  NotificationsResponseEntity? responseToReturn;
  Failure? failureToReturn;

  @override
  Future<Either<Failure, NotificationsResponseEntity>> call(
    GetNotificationsParams params,
  ) async {
    if (failureToReturn != null) return Left(failureToReturn!);
    return Right(responseToReturn!);
  }
}

class FakeMarkNotificationReadUseCase implements MarkNotificationReadUseCase {
  String? markedId;
  @override
  Future<Either<Failure, void>> call(String notificationId) async {
    markedId = notificationId;
    return const Right(null);
  }
}

class FakeMarkAllNotificationsReadUseCase
    implements MarkAllNotificationsReadUseCase {
  bool called = false;
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    called = true;
    return const Right(null);
  }
}

class FakeGetUnreadNotificationsCountUseCase
    implements NotificationsRepository {
  @override
  Future<Either<Failure, int>> getUnreadNotificationsCount() async =>
      const Right(5);

  @override
  Future<Either<Failure, NotificationsResponseEntity>> getNotifications({
    int page = 1,
    bool forceRefresh = false,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> markAllNotificationsRead() async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> markNotificationRead(String id) async =>
      const Right(null);
}

void main() {
  late NotificationsCubit cubit;
  late FakeGetNotificationsUseCase getNotificationsUseCase;
  late FakeMarkNotificationReadUseCase markReadUseCase;
  late FakeMarkAllNotificationsReadUseCase markAllReadUseCase;

  setUp(() {
    getNotificationsUseCase = FakeGetNotificationsUseCase();
    markReadUseCase = FakeMarkNotificationReadUseCase();
    markAllReadUseCase = FakeMarkAllNotificationsReadUseCase();
    cubit = NotificationsCubit(
      getNotificationsUseCase,
      null,
      markReadUseCase,
      markAllReadUseCase,
    );
  });

  test('initial state is NotificationsInitial', () {
    expect(cubit.state, isA<NotificationsInitial>());
  });

  test('getNotifications emits Loaded when successful', () async {
    final notifs = [
      const NotificationItemEntity(
        id: '1',
        title: 'Rent Due',
        body: 'Rent due tomorrow',
        type: 'payment',
        createdAt: '2026-08-17',
      ),
    ];
    getNotificationsUseCase.responseToReturn = NotificationsResponseEntity(
      notifications: notifs,
      meta: const NotificationPaginationMetaEntity(
        currentPage: 1,
        lastPage: 1,
        total: 1,
        perPage: 15,
      ),
      unreadCount: 1,
    );

    await cubit.getNotifications();

    expect(cubit.state, isA<NotificationsLoaded>());
    final loaded = cubit.state as NotificationsLoaded;
    expect(loaded.notifications.length, equals(1));
    expect(loaded.unreadCount, equals(1));
  });

  test('markNotificationAsRead updates item state locally and calls use case',
      () async {
    final notifs = [
      const NotificationItemEntity(
        id: '1',
        title: 'Rent Due',
        body: 'Rent due tomorrow',
        type: 'payment',
        createdAt: '2026-08-17',
        readAt: null,
      ),
    ];
    getNotificationsUseCase.responseToReturn = NotificationsResponseEntity(
      notifications: notifs,
      meta: const NotificationPaginationMetaEntity(
        currentPage: 1,
        lastPage: 1,
        total: 1,
        perPage: 15,
      ),
      unreadCount: 1,
    );

    await cubit.getNotifications();
    await cubit.markNotificationAsRead('1');

    final loaded = cubit.state as NotificationsLoaded;
    expect(loaded.notifications.first.isRead, isTrue);
    expect(loaded.unreadCount, equals(0));
    expect(markReadUseCase.markedId, equals('1'));
  });

  test('changeFilter updates activeFilter in state', () async {
    final notifs = [
      const NotificationItemEntity(
        id: '1',
        title: 'Maintenance',
        body: 'AC Repair',
        type: 'maintenance',
        createdAt: '2026-08-17',
      ),
    ];
    getNotificationsUseCase.responseToReturn = NotificationsResponseEntity(
      notifications: notifs,
      meta: const NotificationPaginationMetaEntity(
        currentPage: 1,
        lastPage: 1,
        total: 1,
        perPage: 15,
      ),
      unreadCount: 0,
    );

    await cubit.getNotifications();
    cubit.changeFilter('maintenance');

    final loaded = cubit.state as NotificationsLoaded;
    expect(loaded.activeFilter, equals('maintenance'));
    expect(loaded.filteredNotifications.length, equals(1));
  });
}
