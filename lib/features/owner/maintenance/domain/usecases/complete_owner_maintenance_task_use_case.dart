import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/owner_maintenance_repository.dart';
import '../entities/maintenance_item_entity.dart';

class CompleteOwnerMaintenanceTaskUseCase
    implements
        UseCase<MaintenanceItemEntity, CompleteOwnerMaintenanceTaskParams> {
  final OwnerMaintenanceRepository repository;

  CompleteOwnerMaintenanceTaskUseCase(this.repository);

  @override
  Future<Either<Failure, MaintenanceItemEntity>> call(
    CompleteOwnerMaintenanceTaskParams params,
  ) async {
    return await repository.completeMaintenanceTask(params);
  }
}

class CompleteOwnerMaintenanceTaskParams {
  final int maintenanceId;
  final int taskId;
  final String technicianResponse;

  CompleteOwnerMaintenanceTaskParams({
    required this.maintenanceId,
    required this.taskId,
    required this.technicianResponse,
  });

  Map<String, dynamic> toJson() {
    return {'status': 'completed', 'technician_response': technicianResponse};
  }
}
