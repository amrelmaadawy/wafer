import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/unit_full_details_entity.dart';
import '../repositories/units_repository.dart';

class GetUnitDetailsUseCase {
  final UnitsRepository _repository;

  GetUnitDetailsUseCase(this._repository);

  Future<Either<Failure, UnitFullDetailsEntity>> call(int propertyId, int unitId) {
    return _repository.getUnitDetails(propertyId, unitId);
  }
}
