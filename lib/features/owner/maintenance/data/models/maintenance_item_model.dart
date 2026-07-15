import '../../domain/entities/maintenance_item_entity.dart';
import 'maintenance_property_ref_model.dart';

class MaintenanceItemModel extends MaintenanceItemEntity {
  const MaintenanceItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
    required super.statusLabel,
    required super.costBearer,
    required super.costBearerLabel,
    required super.estimatedCost,
    required super.actualCost,
    required super.advancePayment,
    required super.property,
    required super.unit,
    required super.requestedDate,
    super.scheduledDate,
    super.completedDate,
    required super.images,
  });

  factory MaintenanceItemModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedImages = [];
    if (json['images'] is List) {
      for (final item in (json['images'] as List)) {
        if (item is String) {
          parsedImages.add(item);
        } else if (item is Map && item['url'] != null) {
          parsedImages.add('${item['url']}');
        } else if (item is Map && item['path'] != null) {
          parsedImages.add('${item['path']}');
        }
      }
    }

    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse('$val') ?? 0.0;
    }

    return MaintenanceItemModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? '',
      statusLabel: json['status_label'] as String? ?? '',
      costBearer: json['cost_bearer'] as String? ?? '',
      costBearerLabel: json['cost_bearer_label'] as String? ?? '',
      estimatedCost: parseDouble(json['estimated_cost']),
      actualCost: parseDouble(json['actual_cost']),
      advancePayment: parseDouble(json['advance_payment']),
      property: MaintenancePropertyRefModel.fromJson(
          json['property'] is Map<String, dynamic> ? json['property'] as Map<String, dynamic> : null),
      unit: MaintenancePropertyRefModel.fromJson(
          json['unit'] is Map<String, dynamic> ? json['unit'] as Map<String, dynamic> : null),
      requestedDate: json['requested_date'] as String? ?? '',
      scheduledDate: json['scheduled_date'] as String?,
      completedDate: json['completed_date'] as String?,
      images: parsedImages,
    );
  }
}
