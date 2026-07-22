import '../../domain/entities/deed_entity.dart';

class DeedModel extends DeedEntity {
  const DeedModel({
    required super.id,
    required super.deedNumber,
    super.deedDate,
    super.city,
    super.district,
    super.ownerName,
  });

  factory DeedModel.fromJson(Map<String, dynamic> json) {
    return DeedModel(
      id: json['id'] as int? ?? 0,
      deedNumber: json['deed_number']?.toString() ?? json['deedNumber']?.toString() ?? '',
      deedDate: json['deed_date']?.toString() ?? json['deedDate']?.toString(),
      city: json['city']?.toString(),
      district: json['district']?.toString(),
      ownerName: json['owner_name']?.toString() ?? json['ownerName']?.toString(),
    );
  }
}
