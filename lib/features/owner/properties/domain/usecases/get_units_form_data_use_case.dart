import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/units_form_data_entity.dart';
import '../repositories/units_repository.dart';

class GetUnitsFormDataUseCase {
  final UnitsRepository repository;

  GetUnitsFormDataUseCase(this.repository);

  Future<Either<Failure, UnitsFormDataEntity>> call() {
    return repository.getUnitsFormData();
  }
}
