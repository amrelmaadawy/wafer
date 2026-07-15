import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/maintenance_item_entity.dart';
import '../repositories/owner_maintenance_repository.dart';

class GetOwnerMaintenanceDetailsUseCase
    implements UseCase<MaintenanceItemEntity, int> {
  final OwnerMaintenanceRepository _repository;

  GetOwnerMaintenanceDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, MaintenanceItemEntity>> call(int id) {
    return _repository.getMaintenanceDetails(id);
  }
}
