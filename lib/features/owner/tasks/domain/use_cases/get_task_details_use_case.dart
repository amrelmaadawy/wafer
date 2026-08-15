import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class GetTaskDetailsUseCase {
  final TasksRepository repository;

  GetTaskDetailsUseCase(this.repository);

  Future<Either<Failure, TaskEntity>> call({required int id}) {
    return repository.getTaskDetails(id: id);
  }
}
