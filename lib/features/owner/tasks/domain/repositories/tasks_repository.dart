import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/task_form_data_entity.dart';

import '../entities/task_entity.dart';
import '../entities/tasks_pagination_meta_entity.dart';
import '../entities/create_task_params.dart';
import '../entities/update_task_params.dart';

abstract class TasksRepository {
  Future<Either<Failure, TaskFormDataEntity>> getTaskFormData();
  Future<Either<Failure, (List<TaskEntity>, TasksPaginationMetaEntity)>> getTasks({
    required int page,
    int perPage = 15,
  });

  Future<Either<Failure, TaskEntity>> getTaskDetails({required int id});
  Future<Either<Failure, TaskEntity>> createTask(CreateTaskParams params);
  Future<Either<Failure, TaskEntity>> updateTask(UpdateTaskParams params);
  Future<Either<Failure, TaskEntity>> updateTaskStatus(int id, String status);
  Future<Either<Failure, TaskEntity>> updateTaskProgress(int id, int progress);
  Future<Either<Failure, TaskEntity>> updateTaskPriority(int id, String priority);
  Future<Either<Failure, TaskEntity>> addTaskComment(int id, String body);
  Future<Either<Failure, TaskEntity>> addTaskAssignee(int id, int userId);
  Future<Either<Failure, TaskEntity>> removeTaskAssignee(int taskId, int assigneeId);
  Future<Either<Failure, TaskEntity>> updateTaskDates(int id, String? startDate, String? dueDate);
  Future<Either<Failure, void>> deleteTask(int id);
}
