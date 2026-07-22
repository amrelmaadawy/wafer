import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/properties_repository.dart';

class PatchPropertyUseCase {
  final PropertiesRepository _repository;

  PatchPropertyUseCase(this._repository);

  Future<Either<Failure, void>> call(int propertyId, Map<String, dynamic> data) {
    return _repository.patchProperty(propertyId, data);
  }
}
