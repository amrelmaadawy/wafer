import '../../domain/entities/property_owner_entity.dart';

class PropertyOwnerModel extends PropertyOwnerEntity {
  const PropertyOwnerModel({
    required super.id,
    required super.name,
    required super.percentage,
    super.phone,
    super.email,
    super.username,
    super.isRepresentative,
  });

  factory PropertyOwnerModel.fromJson(Map<String, dynamic> json) {
    final perc = (json['ownership_percentage'] as num?) ??
        (json['percentage'] as num?) ??
        (json['share'] as num?) ??
        100;

    return PropertyOwnerModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? json['owner_name']?.toString() ?? 'مالك',
      percentage: perc.toDouble(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      username: json['username']?.toString(),
      isRepresentative: json['is_representative'] as bool? ?? false,
    );
  }
}
