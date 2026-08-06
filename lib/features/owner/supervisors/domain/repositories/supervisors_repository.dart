import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/supervisor_entity.dart';
import '../entities/supervisor_form_data_entity.dart';
import '../entities/supervisors_list_response_entity.dart';

abstract class SupervisorsRepository {
  Future<Either<Failure, SupervisorFormDataEntity>> getFormData();
  Future<Either<Failure, SupervisorsListResponseEntity>> getSupervisors(
    int page,
  );
  Future<Either<Failure, SupervisorEntity>> createSupervisor(
    Map<String, dynamic> body,
  );
}
