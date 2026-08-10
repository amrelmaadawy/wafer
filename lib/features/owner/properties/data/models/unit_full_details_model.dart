import '../../domain/entities/unit_full_details_entity.dart';
import '../../../maintenance/data/models/maintenance_item_model.dart';
import 'media_item_model.dart';

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
    super.purpose,
    super.purposeLabel,
    super.floorType,
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
    super.videos = const [],
    super.attachments = const [],
    super.media = const MediaDetailsModel(),
    super.maintenanceRequests = const [],
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
      purpose: json['purpose'] as String? ?? json['unit_purpose'] as String?,
      purposeLabel: json['purpose_label'] as String? ?? json['unit_purpose_label'] as String?,
      floorType: json['floor_type'] as String? ?? json['unit_floor_type'] as String? ?? json['floor'] as String?,
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
      images: (json['images'] as List?)
              ?.map((e) => e is Map ? (e['url'] as String) : e.toString())
              .where((url) {
                final l = url.toLowerCase();
                return !l.endsWith('.mp4') && !l.endsWith('.mov') && !l.endsWith('.avi') && !l.endsWith('.mkv');
              })
              .toList() ??
          [],
      videos: (json['videos'] as List?)
              ?.map((e) => e is Map ? (e['url'] as String) : e.toString())
              .toList() ??
          [],
      attachments: (json['attachments'] as List?)
              ?.map((e) => e is Map ? (e['url'] as String) : e.toString())
              .toList() ??
          [],
      media: json['media'] != null 
          ? MediaDetailsModel.fromJson(json['media'] as Map<String, dynamic>) 
          : const MediaDetailsModel(),
      maintenanceRequests: (json['maintenance_requests'] as List<dynamic>?)
              ?.map((e) => MaintenanceItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      roomsCount: json['rooms']?['rooms_count'] as int? ?? json['details']?['rooms_count'] as int? ?? 0,
      bathroomsCount: json['rooms']?['bathrooms_count'] as int? ?? json['details']?['bathrooms_count'] as int? ?? 0,
      hallsCount: json['rooms']?['halls_count'] as int? ?? json['details']?['halls_count'] as int? ?? 0,
      kitchensCount: json['rooms']?['kitchens_count'] as int? ?? json['details']?['kitchens_count'] as int? ?? 0,
      entrancesCount: json['rooms']?['entrances_count'] as int? ?? json['details']?['entrances_count'] as int? ?? 0,
      rentPrice:
          json['prices']?['annual_rent_monthly'] as num? ?? json['prices']?['monthly'] as num? ?? json['rent_price'] as num? ?? 0,
      monthlyPrice: json['prices']?['annual_rent_monthly'] as num? ?? json['prices']?['monthly'] as num? ?? 0,
      perTwoPaymentsPrice:
          json['prices']?['annual_rent_2_payments'] as num? ??
          json['prices']?['per_two_payments'] as num? ??
          json['prices']?['per_two_months'] as num? ??
          0,
      quarterlyPrice: json['prices']?['annual_rent_4_payments'] as num? ?? json['prices']?['quarterly'] as num? ?? 0,
      currentContract: json['current_contract'],
      contractsHistory: json['contracts_history'] as List<dynamic>? ?? const [],
    );
  }
}
