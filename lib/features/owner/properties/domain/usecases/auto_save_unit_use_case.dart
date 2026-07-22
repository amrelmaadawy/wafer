import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/units_repository.dart';

class AutoSaveUnitUseCase {
  final UnitsRepository _repository;

  AutoSaveUnitUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required int propertyId,
    required int unitId,
    required Map<String, dynamic> data,
  }) {
    return _repository.autoSaveUnit(propertyId, unitId, data);
  }
}
