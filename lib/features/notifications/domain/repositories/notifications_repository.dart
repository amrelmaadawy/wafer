import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notifications_response_entity.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, NotificationsResponseEntity>> getNotifications({
    int page = 1,
    bool forceRefresh = false,
  });

  Future<Either<Failure, int>> getUnreadNotificationsCount();
}
