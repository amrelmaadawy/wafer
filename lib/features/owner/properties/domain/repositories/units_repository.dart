import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/properties_pagination_meta_entity.dart';
import '../entities/unit_full_details_entity.dart';
import '../entities/unit_entity.dart';


abstract class UnitsRepository {
  Future<Either<Failure, ({List<UnitEntity> items, PropertiesPaginationMetaEntity meta})>> getPropertyUnits(
    int propertyId, {
    int page = 1,
    String? search,
    String? unitStatus,
    String? unitType,
  });
  Future<Either<Failure, int>> createDraftUnit(int propertyId);
  Future<Either<Failure, void>> autoSaveUnit(int propertyId, int unitId, Map<String, dynamic> data);
  Future<Either<Failure, UnitFullDetailsEntity>> getUnitDetails(int propertyId, int unitId);
  Future<Either<Failure, void>> publishUnit(int propertyId, int unitId);
}
