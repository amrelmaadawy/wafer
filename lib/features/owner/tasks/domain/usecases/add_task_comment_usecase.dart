import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class AddTaskCommentUseCase {
  final TasksRepository repository;

  AddTaskCommentUseCase(this.repository);

  Future<Either<Failure, TaskEntity>> call(AddTaskCommentParams params) async {
    return await repository.addTaskComment(params.taskId, params.body);
  }
}

class AddTaskCommentParams {
  final int taskId;
  final String body;

  AddTaskCommentParams({
    required this.taskId,
    required this.body,
  });
}
