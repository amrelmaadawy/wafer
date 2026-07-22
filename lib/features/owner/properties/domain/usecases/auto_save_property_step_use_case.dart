import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/properties_repository.dart';

class AutoSavePropertyStepUseCase {
  final PropertiesRepository _repository;

  AutoSavePropertyStepUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required int propertyId,
    required String step,
    required Map<String, dynamic> data,
  }) {
    return _repository.autoSavePropertyStep(
      propertyId: propertyId,
      step: step,
      data: data,
    );
  }
}
