import '../../domain/entities/unit_entity.dart';

class UnitModel extends UnitEntity {
  const UnitModel({
    required super.id,
    required super.propertyId,
    super.name,
    super.code,
    required super.unitNumber,
    super.floor,
    super.area,
    super.type,
    super.typeLabel,
    required super.status,
    super.statusLabel,
    required super.rentPrice,
    super.deposit,
    super.specs,
    super.createdAt,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'] as int? ?? 0,
      propertyId: json['property_id'] as int? ?? json['propertyId'] as int? ?? 0,
      name: json['name']?.toString(),
      code: json['code']?.toString(),
      unitNumber: json['unit_number']?.toString() ?? json['unitNumber']?.toString() ?? json['number']?.toString() ?? '',
      floor: json['floor']?.toString() ?? json['floor_number']?.toString(),
      area: json['area'] as num?,
      type: json['unit_type']?.toString() ?? json['type']?.toString(),
      typeLabel: json['unit_type_label']?.toString(),
      status: json['unit_status']?.toString() ?? json['status']?.toString() ?? 'vacant',
      statusLabel: json['unit_status_label']?.toString(),
      rentPrice: json['rent_amount'] as num? ?? json['annual_rent_monthly'] as num? ?? json['rent_price'] as num? ?? json['price'] as num? ?? 0,
      deposit: json['deposit'] as num?,
      specs: json['specs']?.toString() ?? json['description']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}
