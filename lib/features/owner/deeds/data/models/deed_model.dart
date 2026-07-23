import '../../domain/entities/deed_entity.dart';

class DeedBranchModel extends DeedBranchEntity {
  const DeedBranchModel({
    required super.id,
    required super.name,
  });

  factory DeedBranchModel.fromJson(Map<String, dynamic> json) {
    return DeedBranchModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class DeedPropertyModel extends DeedPropertyEntity {
  const DeedPropertyModel({
    required super.id,
    super.name,
    required super.code,
    super.propertyType,
    super.usageType,
    super.status,
  });

  factory DeedPropertyModel.fromJson(Map<String, dynamic> json) {
    return DeedPropertyModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] as String?,
      code: json['code'] as String? ?? '',
      propertyType: json['property_type'] as String?,
      usageType: json['usage_type'] as String?,
      status: json['status'] as String?,
    );
  }
}

class DeedModel extends DeedEntity {
  const DeedModel({
    required super.id,
    required super.name,
    required super.code,
    super.documentType,
    super.documentNumber,
    super.documentDate,
    required super.area,
    super.documentAttachment,
    super.city,
    super.district,
    super.region,
    super.streetName,
    super.buildingNumber,
    super.shortAddress,
    super.postalCode,
    super.additionalNumber,
    super.latitude,
    super.longitude,
    super.notes,
    super.branch,
    required super.propertiesCount,
    super.createdAt,
    super.properties = const [],
  });

  factory DeedModel.fromJson(Map<String, dynamic> json) {
    return DeedModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      documentType: json['document_type'] as String?,
      documentNumber: json['document_number']?.toString(),
      documentDate: json['document_date'] as String?,
      area: json['area'] is num ? json['area'] as num : num.tryParse(json['area'].toString()) ?? 0,
      documentAttachment: json['document_attachment'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      region: json['region'] as String?,
      streetName: json['street_name'] as String?,
      buildingNumber: json['building_number']?.toString(),
      shortAddress: json['short_address'] as String?,
      postalCode: json['postal_code']?.toString(),
      additionalNumber: json['additional_number']?.toString(),
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      notes: json['notes'] as String?,
      branch: json['branch'] != null ? DeedBranchModel.fromJson(json['branch']) : null,
      propertiesCount: json['properties_count'] is int ? json['properties_count'] as int : int.tryParse(json['properties_count'].toString()) ?? 0,
      createdAt: json['created_at'] as String?,
      properties: json['properties'] != null
          ? (json['properties'] as List).map((e) => DeedPropertyModel.fromJson(e)).toList()
          : const [],
    );
  }
}
