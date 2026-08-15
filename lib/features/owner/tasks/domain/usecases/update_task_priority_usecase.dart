import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskPriorityUseCase {
  final TasksRepository repository;

  UpdateTaskPriorityUseCase(this.repository);

  Future<Either<Failure, TaskEntity>> call(UpdateTaskPriorityParams params) async {
    return await repository.updateTaskPriority(params.id, params.priority);
  }
}

class UpdateTaskPriorityParams {
  final int id;
  final String priority;

  UpdateTaskPriorityParams({
    required this.id,
    required this.priority,
  });
}
