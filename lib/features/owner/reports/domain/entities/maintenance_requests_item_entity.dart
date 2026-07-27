import 'package:equatable/equatable.dart';

class MaintenanceRequestsItemEntity extends Equatable {
  final int id;
  final String requestNumber;
  final String description;
  final String clientName;
  final String clientPhone;
  final PropertyEntity property;
  final UnitEntity unit;
  final String status;
  final String statusLabel;
  final String? priority;
  final String? priorityLabel;
  final String createdAt;

  const MaintenanceRequestsItemEntity({
    required this.id,
    required this.requestNumber,
    required this.description,
    required this.clientName,
    required this.clientPhone,
    required this.property,
    required this.unit,
    required this.status,
    required this.statusLabel,
    this.priority,
    this.priorityLabel,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        requestNumber,
        description,
        clientName,
        clientPhone,
        property,
        unit,
        status,
        statusLabel,
        priority,
        priorityLabel,
        createdAt,
      ];
}

class PropertyEntity extends Equatable {
  final int id;
  final String name;
  final String code;

  const PropertyEntity({
    required this.id,
    required this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}

class UnitEntity extends Equatable {
  final int id;
  final String name;
  final String unitNumber;
  final String status;
  final String statusLabel;

  const UnitEntity({
    required this.id,
    required this.name,
    required this.unitNumber,
    required this.status,
    required this.statusLabel,
  });

  @override
  List<Object?> get props => [id, name, unitNumber, status, statusLabel];
}
