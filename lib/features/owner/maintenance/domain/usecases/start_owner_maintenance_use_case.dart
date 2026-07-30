import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/maintenance_item_entity.dart';
import '../repositories/owner_maintenance_repository.dart';

class StartOwnerMaintenanceUseCase
    implements UseCase<MaintenanceItemEntity, int> {
  final OwnerMaintenanceRepository repository;

  StartOwnerMaintenanceUseCase(this.repository);

  @override
  Future<Either<Failure, MaintenanceItemEntity>> call(int id) async {
    return await repository.startMaintenanceRequest(id);
  }
}
