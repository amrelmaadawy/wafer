import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/properties_repository.dart';

class ClonePropertyUseCase {
  final PropertiesRepository _repository;

  ClonePropertyUseCase(this._repository);

  Future<Either<Failure, int>> call(int propertyId) {
    return _repository.cloneProperty(propertyId);
  }
}
