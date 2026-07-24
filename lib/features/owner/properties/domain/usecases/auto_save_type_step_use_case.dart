import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/property_details_entity.dart';
import '../repositories/properties_repository.dart';

class AutoSaveTypeStepUseCase {
  final PropertiesRepository repository;

  AutoSaveTypeStepUseCase(this.repository);

  Future<Either<Failure, PropertyDetailsEntity>> call({
    required int propertyId,
    required String propertyType,
  }) async {
    return await repository.autoSaveTypeStep(propertyId, propertyType);
  }
}
