import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/properties_repository.dart';

class MakeRepresentativeUseCase {
  final PropertiesRepository _repository;

  MakeRepresentativeUseCase(this._repository);

  Future<Either<Failure, void>> call(int propertyId, Map<String, dynamic> body) {
    return _repository.makeRepresentative(propertyId, body);
  }
}
