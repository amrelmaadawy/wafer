import '../../domain/entities/unit_entity.dart';

class UnitModel extends UnitEntity {
  const UnitModel({
    required super.id,
    required super.propertyId,
    required super.unitNumber,
    super.floor,
    super.area,
    super.type,
    required super.status,
    required super.rentPrice,
    super.deposit,
    super.specs,
    super.createdAt,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'] as int? ?? 0,
      propertyId: json['property_id'] as int? ?? json['propertyId'] as int? ?? 0,
      unitNumber: json['unit_number']?.toString() ?? json['unitNumber']?.toString() ?? json['number']?.toString() ?? '',
      floor: json['floor']?.toString(),
      area: json['area'] as num?,
      type: json['type']?.toString(),
      status: json['status']?.toString() ?? 'vacant',
      rentPrice: json['rent_price'] as num? ?? json['price'] as num? ?? 0,
      deposit: json['deposit'] as num?,
      specs: json['specs']?.toString() ?? json['description']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}
