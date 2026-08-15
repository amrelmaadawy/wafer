import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class RemoveTaskAssigneeUseCase {
  final TasksRepository repository;

  RemoveTaskAssigneeUseCase(this.repository);

  Future<Either<Failure, TaskEntity>> call(RemoveTaskAssigneeParams params) async {
    return await repository.removeTaskAssignee(params.taskId, params.assigneeId);
  }
}

class RemoveTaskAssigneeParams {
  final int taskId;
  final int assigneeId;

  RemoveTaskAssigneeParams({
    required this.taskId,
    required this.assigneeId,
  });
}
