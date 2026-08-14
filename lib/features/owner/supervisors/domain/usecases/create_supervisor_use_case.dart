import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/supervisor_entity.dart';
import '../entities/create_maintenance_supervisor_params.dart';
import '../repositories/supervisors_repository.dart';

class CreateSupervisorUseCase {
  final SupervisorsRepository repository;

  CreateSupervisorUseCase(this.repository);

  Future<Either<Failure, SupervisorEntity>> call(
    CreateMaintenanceSupervisorParams params,
  ) async {
    return await repository.createSupervisor(params);
  }
}
