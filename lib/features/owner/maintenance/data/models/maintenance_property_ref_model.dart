import '../../domain/entities/maintenance_property_ref_entity.dart';

class MaintenancePropertyRefModel extends MaintenancePropertyRefEntity {
  const MaintenancePropertyRefModel({
    required super.id,
    required super.name,
  });

  factory MaintenancePropertyRefModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MaintenancePropertyRefModel(id: 0, name: '');
    }
    return MaintenancePropertyRefModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
