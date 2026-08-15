import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskProgressUseCase implements UseCase<TaskEntity, UpdateTaskProgressParams> {
  final TasksRepository repository;

  UpdateTaskProgressUseCase(this.repository);

  @override
  Future<Either<Failure, TaskEntity>> call(UpdateTaskProgressParams params) async {
    return await repository.updateTaskProgress(params.id, params.progress);
  }
}

class UpdateTaskProgressParams {
  final int id;
  final int progress;

  UpdateTaskProgressParams({required this.id, required this.progress});
}
