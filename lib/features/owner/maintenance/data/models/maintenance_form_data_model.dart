import '../../domain/entities/maintenance_form_data_entity.dart';
import 'maintenance_sub_models.dart';
import 'maintenance_complex_sub_models.dart';

int? _parseIntOrMap(dynamic value) {
  if (value is int) return value;
  if (value is Map<String, dynamic> && value['id'] is int) {
    return value['id'] as int;
  }
  if (value is String) return int.tryParse(value);
  return null;
}

class MaintenanceFormDataUnitModel extends MaintenanceFormDataUnitEntity {
  const MaintenanceFormDataUnitModel({
    required super.id,
    super.propertyId,
    super.propertyName,
    super.name,
    super.unitNumber,
    super.code,
    super.unitType,
    super.unitStatus,
  });

  factory MaintenanceFormDataUnitModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceFormDataUnitModel(
      id: _parseIntOrMap(json['id']) ?? 0,
      propertyId: _parseIntOrMap(json['property_id']),
      propertyName: json['property_name'] as String?,
      name: json['name'] as String?,
      unitNumber: json['unit_number'] as String?,
      code: json['code'] as String?,
      unitType: json['unit_type'] as String?,
      unitStatus: json['unit_status'] as String?,
    );
  }
}

class MaintenanceFormDataPropertyModel
    extends MaintenanceFormDataPropertyEntity {
  const MaintenanceFormDataPropertyModel({
    required super.id,
    super.name,
    super.code,
    super.propertyType,
    super.city,
    super.district,
    required super.units,
  });

  factory MaintenanceFormDataPropertyModel.fromJson(Map<String, dynamic> json) {
    final unitsList = json['units'] as List<dynamic>? ?? [];
    return MaintenanceFormDataPropertyModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      code: json['code'] as String?,
      propertyType: json['property_type'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      units: unitsList
          .map(
            (u) => MaintenanceFormDataUnitModel.fromJson(
              u as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class MaintenanceFormDataModel extends MaintenanceFormDataEntity {
  const MaintenanceFormDataModel({
    required super.properties,
    required super.units,
    required super.maintenanceTypes,
    required super.technicians,
  });

  factory MaintenanceFormDataModel.fromJson(Map<String, dynamic> json) {
    final propertiesList = json['properties'] as List<dynamic>? ?? [];
    final unitsList = json['units'] as List<dynamic>? ?? [];
    final typesList = json['maintenance_types'] as List<dynamic>? ?? [];
    final techniciansList = json['technicians'] as List<dynamic>? ?? [];

    return MaintenanceFormDataModel(
      properties: propertiesList
          .map(
            (p) => MaintenanceFormDataPropertyModel.fromJson(
              p as Map<String, dynamic>,
            ),
          )
          .toList(),
      units: unitsList
          .map(
            (u) => MaintenanceFormDataUnitModel.fromJson(
              u as Map<String, dynamic>,
            ),
          )
          .toList(),
      maintenanceTypes: typesList
          .map((t) => MaintenanceTypeModel.fromJson(t as Map<String, dynamic>))
          .toList(),
      technicians: techniciansList
          .map(
            (t) =>
                MaintenanceTechnicianModel.fromJson(t as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
