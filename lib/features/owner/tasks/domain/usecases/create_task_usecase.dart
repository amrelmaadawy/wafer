import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/create_task_params.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class CreateTaskUseCase implements UseCase<TaskEntity, CreateTaskParams> {
  final TasksRepository repository;

  CreateTaskUseCase(this.repository);

  @override
  Future<Either<Failure, TaskEntity>> call(CreateTaskParams params) async {
    return await repository.createTask(params);
  }
}
