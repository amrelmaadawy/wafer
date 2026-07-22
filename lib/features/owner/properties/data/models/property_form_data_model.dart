import '../../domain/entities/property_form_data_entity.dart';
import 'form_branch_model.dart';
import 'form_deed_model.dart';
import 'form_owner_model.dart';
import 'option_value_label_model.dart';
import 'property_form_step_model.dart';

class PropertyFormOptionsModel extends PropertyFormOptionsEntity {
  const PropertyFormOptionsModel({
    required super.branches,
    required super.owners,
    required super.deeds,
    required super.propertyTypes,
    required super.usageTypes,
    required super.documentTypes,
    required super.propertyStatuses,
    required super.unitTypes,
    required super.unitStatuses,
    required super.unitPurposes,
  });

  factory PropertyFormOptionsModel.fromJson(Map<String, dynamic> json) {
    return PropertyFormOptionsModel(
      branches: (json['branches'] as List<dynamic>? ?? [])
          .map((e) => FormBranchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      owners: (json['owners'] as List<dynamic>? ?? [])
          .map((e) => FormOwnerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      deeds: (json['deeds'] as List<dynamic>? ?? [])
          .map((e) => FormDeedModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      propertyTypes: (json['property_types'] as List<dynamic>? ?? [])
          .map((e) => OptionValueLabelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      usageTypes: (json['usage_types'] as List<dynamic>? ?? [])
          .map((e) => OptionValueLabelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      documentTypes: (json['document_types'] as List<dynamic>? ?? [])
          .map((e) => OptionValueLabelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      propertyStatuses: (json['property_statuses'] as List<dynamic>? ?? [])
          .map((e) => OptionValueLabelModel.fromJson(e as Map<String, dynamic>))
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
    );
  }
}

class PropertyFormDefaultsModel extends PropertyFormDefaultsEntity {
  const PropertyFormDefaultsModel({
    super.defaultOwnerId,
    super.defaultOwnerName,
    super.defaultOwnerPercentage,
    super.isRepresentative = true,
    super.defaultPropertyStatus,
    super.defaultPropertyType,
    super.defaultUnitStatus,
  });

  factory PropertyFormDefaultsModel.fromJson(Map<String, dynamic> json) {
    final ownerMap = json['owner'] as Map<String, dynamic>? ?? {};
    final propMap = json['property'] as Map<String, dynamic>? ?? {};
    final unitMap = json['unit'] as Map<String, dynamic>? ?? {};

    return PropertyFormDefaultsModel(
      defaultOwnerId: ownerMap['id'] as int?,
      defaultOwnerName: ownerMap['name']?.toString(),
      defaultOwnerPercentage: ownerMap['percentage'] as num?,
      isRepresentative: ownerMap['is_representative'] as bool? ?? true,
      defaultPropertyStatus: propMap['status']?.toString(),
      defaultPropertyType: propMap['property_type']?.toString(),
      defaultUnitStatus: unitMap['unit_status']?.toString(),
    );
  }
}

class PropertyFormDataModel extends PropertyFormDataEntity {
  const PropertyFormDataModel({
    required super.steps,
    required super.options,
    required super.defaults,
    required super.endpoints,
  });

  factory PropertyFormDataModel.fromJson(Map<String, dynamic> json) {
    final stepsList = (json['steps'] as List<dynamic>? ?? [])
        .map((e) => PropertyFormStepModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final optionsMap = json['options'] as Map<String, dynamic>? ?? {};
    final options = PropertyFormOptionsModel.fromJson(optionsMap);

    final defaultsMap = json['defaults'] as Map<String, dynamic>? ?? {};
    final defaults = PropertyFormDefaultsModel.fromJson(defaultsMap);

    final endpointsJson = json['endpoints'] as Map<String, dynamic>? ?? {};
    final endpointsMap = endpointsJson.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    return PropertyFormDataModel(
      steps: stepsList,
      options: options,
      defaults: defaults,
      endpoints: endpointsMap,
    );
  }
}
