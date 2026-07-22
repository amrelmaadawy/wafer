import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/units_repository.dart';

class CreateDraftUnitUseCase {
  final UnitsRepository _repository;

  CreateDraftUnitUseCase(this._repository);

  Future<Either<Failure, int>> call(int propertyId) {
    return _repository.createDraftUnit(propertyId);
  }
}
