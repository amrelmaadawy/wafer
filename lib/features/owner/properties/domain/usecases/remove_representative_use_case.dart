import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/properties_repository.dart';

class RemoveRepresentativeUseCase {
  final PropertiesRepository _repository;

  RemoveRepresentativeUseCase(this._repository);

  Future<Either<Failure, void>> call(int propertyId) {
    return _repository.removeRepresentative(propertyId);
  }
}
