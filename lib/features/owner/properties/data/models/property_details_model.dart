import '../../domain/entities/property_details_entity.dart';
import 'property_owner_model.dart';

class PropertyDetailsModel extends PropertyDetailsEntity {
  const PropertyDetailsModel({
    required super.id,
    required super.name,
    required super.code,
    required super.status,
    required super.statusLabel,
    required super.propertyType,
    super.usageType,
    super.constructionYear,
    super.area,
    super.length,
    super.width,
    super.city,
    super.district,
    super.region,
    super.streetName,
    super.buildingNumber,
    super.branchName,
    super.description,
    required super.imageUrls,
    super.deedNumber,
    super.deedDate,
    super.documentType,
    super.deedAttachment,
    super.valuationAmount,
    super.valuationEntity,
    super.valuationDate,
    required super.owners,
    required super.unitsCount,
    required super.rentedUnits,
    required super.availableUnits,
    required super.occupancyRate,
    required super.amenities,
    super.createdAt,
  });

  factory PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    final addrMap = json['address'] is Map<String, dynamic> ? json['address'] as Map<String, dynamic> : null;
    final deedMap = json['deed'] is Map<String, dynamic> ? json['deed'] as Map<String, dynamic> : null;
    final valMap = json['valuation'] is Map<String, dynamic> ? json['valuation'] as Map<String, dynamic> : null;
    final statsMap = json['stats'] is Map<String, dynamic> ? json['stats'] as Map<String, dynamic> : null;
    final dimMap = json['dimensions'] is Map<String, dynamic> ? json['dimensions'] as Map<String, dynamic> : null;
    final branchMap = json['branch'] is Map<String, dynamic> ? json['branch'] as Map<String, dynamic> : null;

    final codeStr = json['code']?.toString() ?? 'PR-${json['id']}';
    final nameStr = json['name']?.toString() ?? codeStr;

    final imagesList = (json['images'] as List<dynamic>? ?? json['image_urls'] as List<dynamic>? ?? [])
        .map((e) => e is Map ? e['url']?.toString() ?? '' : e.toString())
        .where((e) => e.isNotEmpty)
        .toList();

    final ownersList = (json['owners'] as List<dynamic>? ?? [])
        .map((e) => PropertyOwnerModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final amenitiesList = (json['amenities'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    return PropertyDetailsModel(
      id: json['id'] as int? ?? 0,
      name: nameStr,
      code: codeStr,
      status: json['status']?.toString() ?? 'draft',
      statusLabel: json['status_label']?.toString() ?? (json['status'] == 'published' ? 'منشور' : 'مسودة'),
      propertyType: json['property_type']?.toString() ?? json['type']?.toString() ?? 'عقار',
      usageType: json['usage_type']?.toString(),
      constructionYear: json['construction_year'] as int?,
      area: (json['area'] as num?) ?? (dimMap?['area'] as num?),
      length: (json['length'] as num?) ?? (dimMap?['length'] as num?),
      width: (json['width'] as num?) ?? (dimMap?['width'] as num?),
      city: json['city']?.toString() ?? addrMap?['city']?.toString(),
      district: json['district']?.toString() ?? addrMap?['district']?.toString(),
      region: json['region']?.toString() ?? addrMap?['region']?.toString(),
      streetName: json['street_name']?.toString() ?? addrMap?['street_name']?.toString(),
      buildingNumber: json['building_number']?.toString() ?? addrMap?['building_number']?.toString(),
      branchName: branchMap?['name']?.toString(),
      description: json['notes']?.toString() ?? json['description']?.toString(),
      imageUrls: imagesList,
      deedNumber: json['deed_number']?.toString() ?? deedMap?['deed_number']?.toString(),
      deedDate: json['deed_date']?.toString() ?? deedMap?['deed_date']?.toString(),
      documentType: json['document_type']?.toString() ?? deedMap?['document_type']?.toString(),
      deedAttachment: json['deed_attachment']?.toString() ?? deedMap?['attachment']?.toString(),
      valuationAmount: (json['valuation_amount'] as num?) ?? (valMap?['amount'] as num?),
      valuationEntity: valMap?['entity']?.toString(),
      valuationDate: valMap?['date']?.toString(),
      owners: ownersList,
      unitsCount: (json['units_count'] as int?) ?? (statsMap?['total_units'] as int?) ?? 0,
      rentedUnits: (json['rented_units'] as int?) ?? (statsMap?['rented_units'] as int?) ?? 0,
      availableUnits: (json['available_units'] as int?) ?? (statsMap?['available_units'] as int?) ?? 0,
      occupancyRate: (json['occupancy_rate'] as num?) ?? (statsMap?['occupancy_rate'] as num?) ?? 0,
      amenities: amenitiesList,
      createdAt: json['created_at']?.toString(),
    );
  }
}
