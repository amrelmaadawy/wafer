import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/unit_full_details_entity.dart';
import '../entities/unit_update_entity.dart';
import '../repositories/units_repository.dart';

class UpdateUnitUseCase {
  final UnitsRepository repository;

  UpdateUnitUseCase(this.repository);

  Future<Either<Failure, UnitFullDetailsEntity>> call(
    int unitId,
    UnitUpdateEntity unit,
  ) {
    return repository.updateUnit(unitId, unit);
  }
}
