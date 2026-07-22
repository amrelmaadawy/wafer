import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/units_repository.dart';

class PublishUnitUseCase {
  final UnitsRepository _repository;

  PublishUnitUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required int propertyId,
    required int unitId,
  }) {
    return _repository.publishUnit(propertyId, unitId);
  }
}
