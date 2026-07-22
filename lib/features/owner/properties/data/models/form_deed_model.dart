import '../../domain/entities/form_deed_entity.dart';

class FormDeedModel extends FormDeedEntity {
  const FormDeedModel({
    required super.id,
    required super.code,
    required super.name,
    super.branchId,
    super.area,
    super.documentType,
    super.documentNumber,
    super.documentDate,
    super.documentAttachment,
    super.city,
    super.district,
    super.region,
    super.streetName,
    super.buildingNumber,
    super.status,
    super.notes,
    required super.propertiesCount,
  });

  factory FormDeedModel.fromJson(Map<String, dynamic> json) {
    final addressMap = json['address'] as Map<String, dynamic>? ?? {};

    return FormDeedModel(
      id: json['id'] as int? ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      branchId: json['branch_id'] as int?,
      area: json['area'] as num?,
      documentType: json['document_type']?.toString(),
      documentNumber: json['document_number']?.toString(),
      documentDate: json['document_date']?.toString(),
      documentAttachment: json['document_attachment']?.toString(),
      city: addressMap['city']?.toString(),
      district: addressMap['district']?.toString(),
      region: addressMap['region']?.toString(),
      streetName: addressMap['street_name']?.toString(),
      buildingNumber: addressMap['building_number']?.toString(),
      status: json['status']?.toString(),
      notes: json['notes']?.toString(),
      propertiesCount: json['properties_count'] as int? ?? 0,
    );
  }
}
