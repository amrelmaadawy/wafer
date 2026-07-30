import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/maintenance_item_entity.dart';
import '../repositories/owner_maintenance_repository.dart';

class UpdateOwnerMaintenanceParams extends Equatable {
  final int id;
  final String description;
  final String? scheduledDate;
  final List<String> maintenanceTypes;

  const UpdateOwnerMaintenanceParams({
    required this.id,
    required this.description,
    this.scheduledDate,
    required this.maintenanceTypes,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      'maintenance_types': maintenanceTypes,
    };
  }

  @override
  List<Object?> get props => [id, description, scheduledDate, maintenanceTypes];
}

class UpdateOwnerMaintenanceUseCase
    implements UseCase<MaintenanceItemEntity, UpdateOwnerMaintenanceParams> {
  final OwnerMaintenanceRepository _repository;

  UpdateOwnerMaintenanceUseCase(this._repository);

  @override
  Future<Either<Failure, MaintenanceItemEntity>> call(
    UpdateOwnerMaintenanceParams params,
  ) {
    return _repository.updateMaintenanceRequest(params);
  }
}
