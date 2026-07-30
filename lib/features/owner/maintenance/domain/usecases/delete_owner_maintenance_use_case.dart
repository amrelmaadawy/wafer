import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/owner_maintenance_repository.dart';

class DeleteOwnerMaintenanceUseCase implements UseCase<void, int> {
  final OwnerMaintenanceRepository _repository;

  DeleteOwnerMaintenanceUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(int params) {
    return _repository.deleteMaintenanceRequest(params);
  }
}
