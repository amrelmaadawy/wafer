part of 'unit_full_details_model.dart';

UnitFullDetailsModel parseUnitFullDetails(Map<String, dynamic> json) {
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
    purpose: json['purpose'] as String? ?? json['unit_purpose'] as String?,
    purposeLabel:
        json['purpose_label'] as String? ??
        json['unit_purpose_label'] as String?,
    floorType:
        json['floor_type'] as String? ??
        json['unit_floor_type'] as String? ??
        json['floor'] as String?,
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
            ?.map((item) => item.toString())
            .toList() ??
        const [],
    images:
        (json['images'] as List?)
            ?.map(
              (item) => item is Map ? item['url'] as String : item.toString(),
            )
            .where(_isImageUrl)
            .toList() ??
        const [],
    videos:
        (json['videos'] as List?)
            ?.map(
              (item) => item is Map ? item['url'] as String : item.toString(),
            )
            .toList() ??
        const [],
    attachments:
        (json['attachments'] as List?)
            ?.map(
              (item) => item is Map ? item['url'] as String : item.toString(),
            )
            .toList() ??
        const [],
    media: json['media'] != null
        ? MediaDetailsModel.fromJson(json['media'] as Map<String, dynamic>)
        : const MediaDetailsModel(),
    maintenanceRequests:
        (json['maintenance_requests'] as List<dynamic>?)
            ?.map(
              (item) =>
                  MaintenanceItemModel.fromJson(item as Map<String, dynamic>),
            )
            .toList() ??
        const [],
    roomsCount: _detailCount(json, 'rooms_count'),
    bathroomsCount: _detailCount(json, 'bathrooms_count'),
    hallsCount: _detailCount(json, 'halls_count'),
    kitchensCount: _detailCount(json, 'kitchens_count'),
    entrancesCount: _detailCount(json, 'entrances_count'),
    rentPrice:
        json['prices']?['annual_rent_monthly'] as num? ??
        json['prices']?['monthly'] as num? ??
        json['rent_price'] as num? ??
        0,
    monthlyPrice:
        json['prices']?['annual_rent_monthly'] as num? ??
        json['prices']?['monthly'] as num? ??
        0,
    perTwoPaymentsPrice:
        json['prices']?['annual_rent_2_payments'] as num? ??
        json['prices']?['per_two_payments'] as num? ??
        json['prices']?['per_two_months'] as num? ??
        0,
    quarterlyPrice:
        json['prices']?['annual_rent_4_payments'] as num? ??
        json['prices']?['quarterly'] as num? ??
        0,
    currentContract: parseUnitContract(json['current_contract']),
    contractsHistory: parseUnitContracts(json['contracts_history']),
  );
}

int _detailCount(Map<String, dynamic> json, String key) {
  return json['rooms']?[key] as int? ?? json['details']?[key] as int? ?? 0;
}

bool _isImageUrl(String url) {
  final lowerUrl = url.toLowerCase();
  return !lowerUrl.endsWith('.mp4') &&
      !lowerUrl.endsWith('.mov') &&
      !lowerUrl.endsWith('.avi') &&
      !lowerUrl.endsWith('.mkv');
}
