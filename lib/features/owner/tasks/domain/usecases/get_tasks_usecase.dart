import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../entities/tasks_filter_params.dart';
import '../entities/tasks_pagination_meta_entity.dart';
import '../repositories/tasks_repository.dart';

class GetTasksUseCase {
  final TasksRepository repository;

  GetTasksUseCase(this.repository);

  Future<Either<Failure, (List<TaskEntity>, TasksPaginationMetaEntity)>> call({
    TasksFilterParams params = const TasksFilterParams(),
  }) async {
    return await repository.getTasks(params: params);
  }
}
