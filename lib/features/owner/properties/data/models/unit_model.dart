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
    super.isFurnished,
    super.image,
    super.details = const UnitDetailsEntity(),
    super.prices = const UnitPricesEntity(),
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'] as int? ?? 0,
      propertyId: json['property_id'] as int? ?? 0,
      name: json['name'] as String?,
      code: json['code'] as String?,
      unitNumber: json['unit_number'] as String? ?? '',
      floor: json['floor_number']?.toString() ?? json['floor']?.toString(),
      area: json['area'] as num?,
      type: json['unit_type'] as String?,
      typeLabel: json['unit_type_label'] as String?,
      status: json['unit_status'] as String? ?? '',
      statusLabel: json['unit_status_label'] as String?,
      rentPrice:
          json['prices']?['monthly'] as num? ?? json['rent_price'] as num? ?? 0,
      deposit: json['deposit'] as num?,
      specs: json['specs'] as String?,
      createdAt: json['created_at'] as String?,
      isFurnished: json['is_furnished'] as bool? ?? false,
      image: json['image'] as String?,
      details: json['details'] != null
          ? UnitDetailsEntity(
              roomsCount: json['details']['rooms_count'] as int? ?? 0,
              bathroomsCount: json['details']['bathrooms_count'] as int? ?? 0,
              hallsCount: json['details']['halls_count'] as int? ?? 0,
              kitchensCount: json['details']['kitchens_count'] as int? ?? 0,
            )
          : const UnitDetailsEntity(),
      prices: json['prices'] != null
          ? UnitPricesEntity(
              monthly: json['prices']['monthly'] as num? ?? 0,
              perTwoMonths: json['prices']['per_two_months'] as num? ?? 0,
              quarterly: json['prices']['quarterly'] as num? ?? 0,
            )
          : const UnitPricesEntity(),
    );
  }
}
