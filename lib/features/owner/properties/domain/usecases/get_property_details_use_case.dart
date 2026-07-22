import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/property_details_entity.dart';
import '../repositories/properties_repository.dart';

class GetPropertyDetailsUseCase {
  final PropertiesRepository _repository;

  GetPropertyDetailsUseCase(this._repository);

  Future<Either<Failure, PropertyDetailsEntity>> call(int propertyId) {
    return _repository.getPropertyDetails(propertyId);
  }
}
