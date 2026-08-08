import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/units_repository.dart';

class DeleteUnitUseCase {
  final UnitsRepository repository;

  DeleteUnitUseCase(this.repository);

  Future<Either<Failure, void>> call(int unitId) {
    return repository.deleteUnit(unitId);
  }
}
