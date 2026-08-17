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
  final List<String> maintenanceTypes;
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

  factory CreateOwnerMaintenanceParams.fromJson(Map<String, dynamic> json) {
    return CreateOwnerMaintenanceParams(
      propertyId: json['property_id'] as int,
      unitId: json['unit_id'] as int?,
      clientName: json['client_name'] as String? ?? '',
      clientPhone: json['client_phone'] as String? ?? '',
      description: json['description'] as String? ?? '',
      requestedDate: json['requested_date'] as String? ?? '',
      maintenanceTypes: (json['maintenance_types'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isPrivate: json['is_private'] as bool? ?? false,
    );
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
