import '../../domain/entities/units_form_data_entity.dart';
import 'form_branch_model.dart';
import 'option_value_label_model.dart';

class FormPropertyModel extends FormPropertyEntity {
  const FormPropertyModel({
    required super.id,
    super.name,
    required super.code,
  });

  factory FormPropertyModel.fromJson(Map<String, dynamic> json) {
    return FormPropertyModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      code: json['code'] as String? ?? '',
    );
  }
}

class UnitsFormOptionsModel extends UnitsFormOptionsEntity {
  const UnitsFormOptionsModel({
    required super.properties,
    required super.branches,
    required super.unitTypes,
    required super.unitStatuses,
    required super.unitPurposes,
    required super.usageTypes,
    required super.booleanValues,
  });

  factory UnitsFormOptionsModel.fromJson(Map<String, dynamic> json) {
    return UnitsFormOptionsModel(
      properties: (json['properties'] as List<dynamic>? ?? [])
          .map((e) => FormPropertyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      branches: (json['branches'] as List<dynamic>? ?? [])
          .map((e) => FormBranchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      unitTypes: (json['unit_types'] as List<dynamic>? ?? [])
          .map((e) => OptionValueLabelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      unitStatuses: (json['unit_statuses'] as List<dynamic>? ?? [])
          .map((e) => OptionValueLabelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      unitPurposes: (json['unit_purposes'] as List<dynamic>? ?? [])
          .map((e) => OptionValueLabelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      usageTypes: (json['usage_types'] as List<dynamic>? ?? [])
          .map((e) => OptionValueLabelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      booleanValues: (json['boolean_values'] as List<dynamic>? ?? [])
          .map((e) => OptionValueLabelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class UnitsFormDataModel extends UnitsFormDataEntity {
  const UnitsFormDataModel({
    required super.options,
  });

  factory UnitsFormDataModel.fromJson(Map<String, dynamic> json) {
    final optionsMap = json['options'] as Map<String, dynamic>? ?? {};
    final options = UnitsFormOptionsModel.fromJson(optionsMap);

    return UnitsFormDataModel(
      options: options,
    );
  }
}
