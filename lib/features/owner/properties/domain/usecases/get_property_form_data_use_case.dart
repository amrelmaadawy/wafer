import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/property_form_data_entity.dart';
import '../repositories/properties_repository.dart';

class GetPropertyFormDataUseCase implements UseCase<PropertyFormDataEntity, NoParams> {
  final PropertiesRepository repository;

  GetPropertyFormDataUseCase(this.repository);

  @override
  Future<Either<Failure, PropertyFormDataEntity>> call(NoParams params) {
    return repository.getPropertyFormData();
  }
}
