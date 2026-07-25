import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/property_details_entity.dart';
import '../repositories/properties_repository.dart';

class MakeRepresentativeUseCase {
  final PropertiesRepository _repository;

  MakeRepresentativeUseCase(this._repository);

  Future<Either<Failure, PropertyDetailsEntity>> call(int propertyId, int ownerId) {
    return _repository.makeRepresentative(propertyId, ownerId);
  }
}
