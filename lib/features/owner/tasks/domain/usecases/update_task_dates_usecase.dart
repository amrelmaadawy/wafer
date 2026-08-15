import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskDatesUseCase {
  final TasksRepository repository;

  UpdateTaskDatesUseCase(this.repository);

  Future<Either<Failure, TaskEntity>> call(UpdateTaskDatesParams params) async {
    return await repository.updateTaskDates(params.id, params.startDate, params.dueDate);
  }
}

class UpdateTaskDatesParams {
  final int id;
  final String? startDate;
  final String? dueDate;

  UpdateTaskDatesParams({
    required this.id,
    this.startDate,
    this.dueDate,
  });
}
