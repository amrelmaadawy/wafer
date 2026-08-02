import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/task_form_data_entity.dart';

abstract class OwnerTasksRepository {
  Future<Either<Failure, TaskFormDataEntity>> getTaskFormData();
}
