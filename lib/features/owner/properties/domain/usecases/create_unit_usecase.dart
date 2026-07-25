import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/unit_create_entity.dart';
import '../repositories/units_repository.dart';

class CreateUnitUseCase {
  final UnitsRepository repository;

  CreateUnitUseCase(this.repository);

  Future<Either<Failure, int>> call(int propertyId, UnitCreateEntity unit) {
    return repository.createUnitDirect(propertyId, unit);
  }
}
