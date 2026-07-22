import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/properties_repository.dart';

class CreateDraftPropertyUseCase {
  final PropertiesRepository _repository;

  CreateDraftPropertyUseCase(this._repository);

  Future<Either<Failure, int>> call(Map<String, dynamic> body) {
    return _repository.createDraftProperty(body);
  }
}
