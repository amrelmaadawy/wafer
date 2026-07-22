import '../../domain/entities/property_list_item_entity.dart';

class PropertyListItemModel extends PropertyListItemEntity {
  const PropertyListItemModel({
    required super.id,
    required super.name,
    required super.code,
    required super.status,
    required super.statusLabel,
    required super.propertyType,
    super.usageType,
    super.area,
    super.city,
    super.district,
    super.deedNumber,
    super.primaryOwnerName,
    required super.unitsCount,
    required super.availableUnits,
    required super.rentedUnits,
    required super.occupancyRate,
    super.imageUrl,
  });

  factory PropertyListItemModel.fromJson(Map<String, dynamic> json) {
    final addrMap = json['address'] as Map<String, dynamic>?;
    final deedMap = json['deed'] as Map<String, dynamic>?;
    final ownerMap = json['primary_owner'] as Map<String, dynamic>? ?? json['owner'] as Map<String, dynamic>?;
    final statsMap = json['stats'] as Map<String, dynamic>?;
    final dimMap = json['dimensions'] as Map<String, dynamic>?;

    final codeStr = json['code']?.toString() ?? '';
    final nameStr = json['name']?.toString() ?? codeStr;

    return PropertyListItemModel(
      id: json['id'] as int? ?? 0,
      name: nameStr.isEmpty ? codeStr : nameStr,
      code: codeStr,
      status: json['status']?.toString() ?? 'draft',
      statusLabel: json['status_label']?.toString() ?? '',
      propertyType: json['property_type']?.toString() ?? '',
      usageType: json['usage_type']?.toString(),
      area: (json['area'] as num?) ?? (dimMap?['area'] as num?),
      city: json['city']?.toString() ?? addrMap?['city']?.toString(),
      district: json['district']?.toString() ?? addrMap?['district']?.toString(),
      deedNumber: json['deed_number']?.toString() ?? deedMap?['deed_number']?.toString(),
      primaryOwnerName: ownerMap?['name']?.toString(),
      unitsCount: (json['units_count'] as int?) ?? (statsMap?['total_units'] as int?) ?? 0,
      availableUnits: (json['available_units'] as int?) ?? (statsMap?['available_units'] as int?) ?? 0,
      rentedUnits: (json['rented_units'] as int?) ?? (statsMap?['rented_units'] as int?) ?? 0,
      occupancyRate: (json['occupancy_rate'] as num?) ?? (statsMap?['occupancy_rate'] as num?) ?? 0,
      imageUrl: json['image']?.toString() ?? json['image_url']?.toString(),
    );
  }
}
