import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/property_details_entity.dart';
import '../repositories/properties_repository.dart';

class AutoSaveDeedStepUseCase {
  final PropertiesRepository repository;

  AutoSaveDeedStepUseCase(this.repository);

  Future<Either<Failure, PropertyDetailsEntity>> call({
    required int propertyId,
    required int deedId,
    required int branchId,
  }) async {
    return await repository.autoSaveDeedStep(propertyId, deedId, branchId);
  }
}
