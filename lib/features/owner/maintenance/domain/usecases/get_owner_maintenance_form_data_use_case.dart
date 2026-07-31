import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/maintenance_form_data_entity.dart';
import '../repositories/owner_maintenance_repository.dart';

class GetOwnerMaintenanceFormDataUseCase {
  final OwnerMaintenanceRepository _repository;

  GetOwnerMaintenanceFormDataUseCase(this._repository);

  Future<Either<Failure, MaintenanceFormDataEntity>> call() async {
    return await _repository.getFormData();
  }
}
