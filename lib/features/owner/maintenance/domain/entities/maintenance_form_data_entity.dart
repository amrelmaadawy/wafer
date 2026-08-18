import 'package:equatable/equatable.dart';
import 'maintenance_sub_entities.dart';
import 'maintenance_complex_sub_entities.dart';

class MaintenanceFormDataUnitEntity extends Equatable {
  final int id;
  final int? propertyId;
  final String? propertyName;
  final String? name;
  final String? unitNumber;
  final String? code;
  final String? unitType;
  final String? unitStatus;

  const MaintenanceFormDataUnitEntity({
    required this.id,
    this.propertyId,
    this.propertyName,
    this.name,
    this.unitNumber,
    this.code,
    this.unitType,
    this.unitStatus,
  });

  String get displayName => name ?? unitNumber ?? code ?? id.toString();

  @override
  List<Object?> get props => [
    id,
    propertyId,
    propertyName,
    name,
    unitNumber,
    code,
    unitType,
    unitStatus,
  ];
}

class MaintenanceFormDataPropertyEntity extends Equatable {
  final int id;
  final String? name;
  final String? code;
  final String? propertyType;
  final String? city;
  final String? district;
  final List<MaintenanceFormDataUnitEntity> units;

  const MaintenanceFormDataPropertyEntity({
    required this.id,
    this.name,
    this.code,
    this.propertyType,
    this.city,
    this.district,
    required this.units,
  });

  String get displayName => name ?? code ?? id.toString();

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    propertyType,
    city,
    district,
    units,
  ];
}

class MaintenanceFormDataEntity extends Equatable {
  final List<MaintenanceFormDataPropertyEntity> properties;
  final List<MaintenanceFormDataUnitEntity> units;
  final List<MaintenanceTypeEntity> maintenanceTypes;
  final List<MaintenanceTechnicianEntity> technicians;
  final List<MaintenanceStatusOptionEntity> statuses;
  final List<MaintenancePriorityOptionEntity> priorities;
  final List<MaintenanceCostBearerOptionEntity> costBearers;

  const MaintenanceFormDataEntity({
    required this.properties,
    required this.units,
    required this.maintenanceTypes,
    required this.technicians,
    this.statuses = const [],
    this.priorities = const [],
    this.costBearers = const [],
  });

  @override
  List<Object?> get props => [
    properties,
    units,
    maintenanceTypes,
    technicians,
    statuses,
    priorities,
    costBearers,
  ];
}
