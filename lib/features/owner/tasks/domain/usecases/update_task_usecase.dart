import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../entities/update_task_params.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskUseCase {
  final TasksRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<Either<Failure, TaskEntity>> call(UpdateTaskParams params) {
    return repository.updateTask(params);
  }
}
