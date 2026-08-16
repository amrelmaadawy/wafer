import '../../domain/entities/maintenance_entity.dart';

class MaintenanceModel extends MaintenanceEntity {
  const MaintenanceModel({
    required super.id,
    required super.requestNumber,
    required super.description,
    required super.status,
    required super.statusLabel,
    super.estimatedCost = 0,
    super.actualCost = 0,
    super.requestedDate,
    super.propertyId,
    super.propertyName,
    super.unitId,
    required super.unitName,
    super.tenantId,
    super.tenantName,
    super.contractId,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    final propertyMap = json['property'] is Map<String, dynamic>
        ? json['property'] as Map<String, dynamic>
        : null;
    final unitMap = json['unit'] is Map<String, dynamic>
        ? json['unit'] as Map<String, dynamic>
        : null;
    final tenantMap = json['tenant'] is Map<String, dynamic>
        ? json['tenant'] as Map<String, dynamic>
        : json['client'] is Map<String, dynamic>
        ? json['client'] as Map<String, dynamic>
        : null;

    return MaintenanceModel(
      id: json['id'] as int? ?? 0,
      requestNumber: json['request_number']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      statusLabel: json['status_label']?.toString() ?? json['status']?.toString() ?? '',
      estimatedCost: json['estimated_cost'] as num? ?? 0,
      actualCost: json['actual_cost'] as num? ?? 0,
      requestedDate: json['requested_date']?.toString(),
      propertyId: json['property_id'] as int? ?? propertyMap?['id'] as int?,
      propertyName: json['property_name']?.toString() ?? propertyMap?['name']?.toString(),
      unitId: json['unit_id'] as int? ?? unitMap?['id'] as int?,
      unitName: unitMap?['name']?.toString() ?? json['unit_name']?.toString() ?? '',
      tenantId: json['tenant_id'] as int? ?? tenantMap?['id'] as int?,
      tenantName: json['tenant_name']?.toString() ?? tenantMap?['name']?.toString(),
      contractId: json['contract_id'] as int?,
    );
  }
}
