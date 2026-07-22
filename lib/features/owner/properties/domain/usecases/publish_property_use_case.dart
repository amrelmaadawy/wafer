import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/properties_repository.dart';

class PublishPropertyUseCase {
  final PropertiesRepository _repository;

  PublishPropertyUseCase(this._repository);

  Future<Either<Failure, void>> call(int propertyId) {
    return _repository.publishProperty(propertyId);
  }
}
