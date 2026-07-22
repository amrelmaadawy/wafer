import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/property_form_options_entity.dart';
import '../repositories/properties_repository.dart';

class GetPropertyFormOptionsUseCase {
  final PropertiesRepository _repository;

  GetPropertyFormOptionsUseCase(this._repository);

  Future<Either<Failure, PropertyFormOptionsEntity>> call() {
    return _repository.getFormOptions();
  }
}
