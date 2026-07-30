import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/properties_pagination_meta_entity.dart';
import '../entities/unit_entity.dart';
import '../repositories/units_repository.dart';

class GetPropertyUnitsUseCase {
  final UnitsRepository _repository;

  GetPropertyUnitsUseCase(this._repository);

  Future<
    Either<
      Failure,
      ({List<UnitEntity> items, PropertiesPaginationMetaEntity meta})
    >
  >
  call(
    int propertyId, {
    int page = 1,
    String? search,
    String? unitStatus,
    String? unitType,
  }) async {
    return await _repository.getPropertyUnits(
      propertyId,
      page: page,
      search: search,
      unitStatus: unitStatus,
      unitType: unitType,
    );
  }
}
