import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/unit_entity.dart';

abstract class UnitsRepository {
  Future<Either<Failure, List<UnitEntity>>> getPropertyUnits(int propertyId);
  Future<Either<Failure, int>> createDraftUnit(int propertyId);
  Future<Either<Failure, void>> autoSaveUnit(int propertyId, int unitId, Map<String, dynamic> data);
  Future<Either<Failure, UnitEntity>> getUnitDetails(int propertyId, int unitId);
  Future<Either<Failure, void>> publishUnit(int propertyId, int unitId);
}
