import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/error/failures.dart';
import 'package:wafer/core/usecases/usecase.dart';
import 'package:wafer/features/notifications/domain/entities/notifications_response_entity.dart';
import 'package:wafer/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:wafer/features/notifications/domain/usecases/mark_all_notifications_read_use_case.dart';
import 'package:wafer/features/notifications/domain/usecases/mark_notification_read_use_case.dart';

class FakeNotificationsRepository implements NotificationsRepository {
  String? lastMarkedId;
  bool markAllCalled = false;

  @override
  Future<Either<Failure, NotificationsResponseEntity>> getNotifications({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> getUnreadNotificationsCount() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> markNotificationRead(
    String notificationId,
  ) async {
    lastMarkedId = notificationId;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> markAllNotificationsRead() async {
    markAllCalled = true;
    return const Right(null);
  }
}

void main() {
  late FakeNotificationsRepository fakeRepository;
  late MarkNotificationReadUseCase markOneUseCase;
  late MarkAllNotificationsReadUseCase markAllUseCase;

  setUp(() {
    fakeRepository = FakeNotificationsRepository();
    markOneUseCase = MarkNotificationReadUseCase(fakeRepository);
    markAllUseCase = MarkAllNotificationsReadUseCase(fakeRepository);
  });

  test('markNotificationRead forwards call to repository', () async {
    final result = await markOneUseCase('123');

    expect(result, equals(const Right(null)));
    expect(fakeRepository.lastMarkedId, equals('123'));
  });

  test('markAllNotificationsRead forwards call to repository', () async {
    final result = await markAllUseCase(const NoParams());

    expect(result, equals(const Right(null)));
    expect(fakeRepository.markAllCalled, isTrue);
  });
}
