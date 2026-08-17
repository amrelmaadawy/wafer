import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notifications_repository.dart';

class MarkAllNotificationsReadUseCase implements UseCase<void, NoParams> {
  final NotificationsRepository _repository;

  MarkAllNotificationsReadUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.markAllNotificationsRead();
  }
}
