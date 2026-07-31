import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/technician_form_data_entity.dart';
import '../entities/technicians_list_response_entity.dart';

import '../entities/technician_entity.dart';
import '../usecases/add_technician_use_case.dart';

abstract class TechniciansRepository {
  Future<Either<Failure, TechnicianFormDataEntity>> getTechnicianFormData();
  Future<Either<Failure, TechniciansListResponseEntity>> getTechniciansList({
    required int page,
    Map<String, dynamic>? filters,
  });
  Future<Either<Failure, TechnicianEntity>> addTechnician(AddTechnicianParams params);
}
