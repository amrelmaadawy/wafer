import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/technician_form_data_entity.dart';
import '../repositories/technicians_repository.dart';

class GetTechnicianFormDataUseCase
    implements UseCase<TechnicianFormDataEntity, NoParams> {
  final TechniciansRepository _repository;

  GetTechnicianFormDataUseCase(this._repository);

  @override
  Future<Either<Failure, TechnicianFormDataEntity>> call(NoParams params) {
    return _repository.getTechnicianFormData();
  }
}
