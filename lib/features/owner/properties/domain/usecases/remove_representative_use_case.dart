import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/property_details_entity.dart';
import '../repositories/properties_repository.dart';

class RemoveRepresentativeUseCase {
  final PropertiesRepository _repository;

  RemoveRepresentativeUseCase(this._repository);

  Future<Either<Failure, PropertyDetailsEntity>> call(int propertyId, int ownerId) {
    return _repository.removeRepresentative(propertyId, ownerId);
  }
}
