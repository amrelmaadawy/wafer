import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/unit_entity.dart';
import '../repositories/units_repository.dart';

class GetPropertyUnitsUseCase {
  final UnitsRepository _repository;

  GetPropertyUnitsUseCase(this._repository);

  Future<Either<Failure, List<UnitEntity>>> call(int propertyId) {
    return _repository.getPropertyUnits(propertyId);
  }
}
