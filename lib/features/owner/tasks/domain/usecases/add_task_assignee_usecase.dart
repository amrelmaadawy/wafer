import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class AddTaskAssigneeUseCase {
  final TasksRepository repository;

  AddTaskAssigneeUseCase(this.repository);

  Future<Either<Failure, TaskEntity>> call(AddTaskAssigneeParams params) async {
    return await repository.addTaskAssignee(params.taskId, params.userId);
  }
}

class AddTaskAssigneeParams {
  final int taskId;
  final int userId;

  AddTaskAssigneeParams({
    required this.taskId,
    required this.userId,
  });
}
