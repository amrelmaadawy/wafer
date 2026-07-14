import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notifications_repository.dart';

class GetUnreadNotificationsCountUseCase implements UseCase<int, NoParams> {
  final NotificationsRepository _repository;

  GetUnreadNotificationsCountUseCase(this._repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return _repository.getUnreadNotificationsCount();
  }
}
