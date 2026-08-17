import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notifications_repository.dart';

class MarkNotificationReadUseCase implements UseCase<void, String> {
  final NotificationsRepository _repository;

  MarkNotificationReadUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String notificationId) {
    return _repository.markNotificationRead(notificationId);
  }
}
