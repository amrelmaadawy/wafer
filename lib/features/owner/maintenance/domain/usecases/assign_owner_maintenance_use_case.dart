import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/owner_maintenance_repository.dart';

class AssignOwnerMaintenanceUseCase
    implements UseCase<void, AssignOwnerMaintenanceParams> {
  final OwnerMaintenanceRepository repository;

  AssignOwnerMaintenanceUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
    AssignOwnerMaintenanceParams params,
  ) async {
    return await repository.assignMaintenanceRequest(params);
  }
}

class AssignOwnerMaintenanceParams {
  final int id;
  final int technicianId;
  final String dueDate;
  final String taskDetails;
  final List<String> tasks;

  const AssignOwnerMaintenanceParams({
    required this.id,
    required this.technicianId,
    required this.dueDate,
    required this.taskDetails,
    required this.tasks,
  });

  Map<String, dynamic> toJson() => {
    'technician_id': technicianId,
    'due_date': dueDate,
    'task_details': taskDetails,
    'tasks': tasks,
  };
}
