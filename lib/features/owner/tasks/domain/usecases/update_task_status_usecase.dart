import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskStatusUseCase {
  final TasksRepository repository;

  UpdateTaskStatusUseCase(this.repository);

  Future<Either<Failure, TaskEntity>> call(int id, String status) async {
    return await repository.updateTaskStatus(id, status);
  }
}
