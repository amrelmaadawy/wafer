import '../../domain/entities/maintenance_requests_item_entity.dart';

class MaintenanceRequestsItemModel extends MaintenanceRequestsItemEntity {
  const MaintenanceRequestsItemModel({
    required super.id,
    required super.requestNumber,
    required super.description,
    required super.clientName,
    required super.clientPhone,
    required super.property,
    required super.unit,
    required super.status,
    required super.statusLabel,
    super.priority,
    super.priorityLabel,
    required super.createdAt,
  });

  factory MaintenanceRequestsItemModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequestsItemModel(
      id: json['id'] ?? 0,
      requestNumber: json['request_number'] ?? '',
      description: json['description'] ?? '',
      clientName: json['client_name'] ?? '',
      clientPhone: json['client_phone'] ?? '',
      property: PropertyModel.fromJson(json['property'] ?? {}),
      unit: UnitModel.fromJson(json['unit'] ?? {}),
      status: json['status'] ?? '',
      statusLabel: json['status_label'] ?? '',
      priority: json['priority'],
      priorityLabel: json['priority_label'],
      createdAt: json['created_at'] ?? '',
    );
  }
}

class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required super.id,
    required super.name,
    required super.code,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class UnitModel extends UnitEntity {
  const UnitModel({
    required super.id,
    required super.name,
    required super.unitNumber,
    required super.status,
    required super.statusLabel,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      unitNumber: json['unit_number'] ?? '',
      status: json['status'] ?? '',
      statusLabel: json['status_label'] ?? '',
    );
  }
}
