import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/properties_repository.dart';

class SyncOwnersUseCase {
  final PropertiesRepository _repository;

  SyncOwnersUseCase(this._repository);

  Future<Either<Failure, void>> call(
    int propertyId,
    List<Map<String, dynamic>> owners,
  ) {
    return _repository.syncOwners(propertyId, owners);
  }
}
