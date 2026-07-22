import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/properties_repository.dart';

class DeletePropertyUseCase {
  final PropertiesRepository _repository;

  DeletePropertyUseCase(this._repository);

  Future<Either<Failure, void>> call(int propertyId) {
    return _repository.deleteProperty(propertyId);
  }
}
