import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/owner_maintenance_repository.dart';

class CreateOwnerMaintenanceParams extends Equatable {
  final int propertyId;
  final int? unitId;
  final String clientName;
  final String clientPhone;
  final String description;
  final String requestedDate;
  final List<dynamic> maintenanceTypes;
  final bool isPrivate;

  const CreateOwnerMaintenanceParams({
    required this.propertyId,
    this.unitId,
    required this.clientName,
    required this.clientPhone,
    required this.description,
    required this.requestedDate,
    required this.maintenanceTypes,
    this.isPrivate = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'property_id': propertyId,
      if (unitId != null) 'unit_id': unitId,
      'client_name': clientName,
      'client_phone': clientPhone,
      'description': description,
      'requested_date': requestedDate,
      'maintenance_types': maintenanceTypes,
      'is_private': isPrivate,
    };
  }

  @override
  List<Object?> get props => [
        propertyId,
        unitId,
        clientName,
        clientPhone,
        description,
        requestedDate,
        maintenanceTypes,
        isPrivate,
      ];
}

class CreateOwnerMaintenanceUseCase
    implements UseCase<void, CreateOwnerMaintenanceParams> {
  final OwnerMaintenanceRepository _repository;

  CreateOwnerMaintenanceUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(CreateOwnerMaintenanceParams params) {
    return _repository.createMaintenanceRequest(params);
  }
}
