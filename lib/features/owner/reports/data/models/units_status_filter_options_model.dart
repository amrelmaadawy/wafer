import '../../domain/entities/units_status_filter_options_entity.dart';
import 'report_model_parsing.dart';

class UnitsStatusFilterOptionsModel extends UnitsStatusFilterOptionsEntity {
  const UnitsStatusFilterOptionsModel({
    required super.statuses,
    required super.properties,
  });

  factory UnitsStatusFilterOptionsModel.fromJson(Map<String, dynamic> json) {
    return UnitsStatusFilterOptionsModel(
      statuses:
          (json['statuses'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(UnitsStatusStatusFilterModel.fromJson)
              .toList() ??
          [],
      properties:
          (json['properties'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(UnitsStatusPropertyFilterModel.fromJson)
              .toList() ??
          [],
    );
  }
}

class UnitsStatusStatusFilterModel extends UnitsStatusStatusFilterEntity {
  const UnitsStatusStatusFilterModel({
    required super.value,
    required super.label,
  });

  factory UnitsStatusStatusFilterModel.fromJson(Map<String, dynamic> json) {
    return UnitsStatusStatusFilterModel(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }
}

class UnitsStatusPropertyFilterModel extends UnitsStatusPropertyFilterEntity {
  const UnitsStatusPropertyFilterModel({
    required super.id,
    super.name,
    required super.code,
  });

  factory UnitsStatusPropertyFilterModel.fromJson(Map<String, dynamic> json) {
    return UnitsStatusPropertyFilterModel(
      id: reportInt(json['id']),
      name: json['name']?.toString(),
      code: json['code']?.toString() ?? '',
    );
  }
}
