import '../../domain/entities/unit_full_details_entity.dart';

class UnitFullDetailsModel extends UnitFullDetailsEntity {
  const UnitFullDetailsModel({
    required super.id,
    super.propertyId,
    super.name,
    required super.unitNumber,
    super.code,
    super.type,
    super.typeLabel,
    required super.status,
    super.statusLabel,
    super.usageType,
    super.floor,
    super.area,
    super.length,
    super.width,
    super.height,
    super.facadeLength,
    super.direction,
    super.isFurnished,
    super.finishingType,
    super.description,
    super.meters = const UnitMetersEntity(),
    super.amenities = const [],
    super.images = const [],
    super.roomsCount,
    super.bathroomsCount,
    super.hallsCount,
    super.kitchensCount,
    super.entrancesCount,
    required super.rentPrice,
    super.monthlyPrice,
    super.perTwoPaymentsPrice,
    super.quarterlyPrice,
    super.currentContract,
    super.contractsHistory,
  });

  factory UnitFullDetailsModel.fromJson(Map<String, dynamic> json) {
    return UnitFullDetailsModel(
      id: json['id'] as int? ?? 0,
      propertyId: json['property_id'] as int? ?? 0,
      name: json['name'] as String?,
      code: json['code'] as String?,
      unitNumber: json['unit_number'] as String? ?? '',
      type: json['unit_type'] as String?,
      typeLabel: json['unit_type_label'] as String?,
      status: json['unit_status'] as String? ?? '',
      statusLabel: json['unit_status_label'] as String?,
      usageType: json['usage_type'] as String?,
      floor: json['floor_number']?.toString() ?? json['floor']?.toString(),
      area: json['area'] as num?,
      length: json['length'] as num?,
      width: json['width'] as num?,
      height: json['height'] as num?,
      facadeLength: json['facade_length'] as num?,
      direction: json['direction'] as String?,
      isFurnished: json['is_furnished'] as bool? ?? false,
      finishingType: json['finishing_type'] as String?,
      description: json['description'] as String?,
      meters: json['meters'] != null
          ? UnitMetersEntity(
              electricity: json['meters']['electricity'] as String?,
              water: json['meters']['water'] as String?,
              gas: json['meters']['gas'] as String?,
            )
          : const UnitMetersEntity(),
      amenities:
          (json['amenities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      roomsCount: json['details']?['rooms_count'] as int? ?? 0,
      bathroomsCount: json['details']?['bathrooms_count'] as int? ?? 0,
      hallsCount: json['details']?['halls_count'] as int? ?? 0,
      kitchensCount: json['details']?['kitchens_count'] as int? ?? 0,
      entrancesCount: json['details']?['entrances_count'] as int? ?? 0,
      rentPrice:
          json['prices']?['monthly'] as num? ?? json['rent_price'] as num? ?? 0,
      monthlyPrice: json['prices']?['monthly'] as num? ?? 0,
      perTwoPaymentsPrice:
          json['prices']?['per_two_payments'] as num? ??
          json['prices']?['per_two_months'] as num? ??
          0,
      quarterlyPrice: json['prices']?['quarterly'] as num? ?? 0,
      currentContract: json['current_contract'],
      contractsHistory: json['contracts_history'] as List<dynamic>? ?? const [],
    );
  }
}
