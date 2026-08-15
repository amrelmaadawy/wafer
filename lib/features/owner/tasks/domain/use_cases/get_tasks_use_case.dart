import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../entities/tasks_pagination_meta_entity.dart';
import '../repositories/tasks_repository.dart';

class GetTasksUseCase {
  final TasksRepository repository;

  GetTasksUseCase(this.repository);

  Future<Either<Failure, (List<TaskEntity>, TasksPaginationMetaEntity)>> call({
    required int page,
    int perPage = 15,
  }) async {
    return await repository.getTasks(page: page, perPage: perPage);
  }
}
