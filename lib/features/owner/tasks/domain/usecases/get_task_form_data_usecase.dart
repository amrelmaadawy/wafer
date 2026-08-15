import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/task_form_data_entity.dart';
import '../repositories/tasks_repository.dart';

class GetTaskFormDataUseCase implements UseCase<TaskFormDataEntity, NoParams> {
  final TasksRepository repository;

  GetTaskFormDataUseCase(this.repository);

  @override
  Future<Either<Failure, TaskFormDataEntity>> call(NoParams params) async {
    return await repository.getTaskFormData();
  }
}
