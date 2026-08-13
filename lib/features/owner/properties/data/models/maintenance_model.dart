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
    required super.unitName,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    final unitMap = json['unit'] is Map<String, dynamic>
        ? json['unit'] as Map<String, dynamic>
        : null;

    return MaintenanceModel(
      id: json['id'] as int? ?? 0,
      requestNumber: json['request_number']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      statusLabel: json['status_label']!.toString(),
      estimatedCost: json['estimated_cost'] as num? ?? 0,
      actualCost: json['actual_cost'] as num? ?? 0,
      requestedDate: json['requested_date']?.toString(),
      unitName: unitMap?['name']?.toString() ?? '',
    );
  }
}
