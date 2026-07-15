import '../../domain/entities/defaulter_entity.dart';

class DefaulterModel extends DefaulterEntity {
  const DefaulterModel({
    required super.id,
    required super.tenantName,
    required super.unitName,
    required super.propertyName,
    required super.overdueAmount,
    required super.overdueSince,
    required super.installmentsCount,
  });

  factory DefaulterModel.fromJson(Map<String, dynamic> json) {
    return DefaulterModel(
      id: _parseInt(json['id']),
      tenantName: json['tenant_name']?.toString() ?? '',
      unitName: json['unit_name']?.toString() ?? '',
      propertyName: json['property_name']?.toString() ?? '',
      overdueAmount: _parseDouble(json['overdue_amount']),
      overdueSince: json['overdue_since']?.toString() ?? '',
      installmentsCount: _parseInt(json['installments_count']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
