import 'package:equatable/equatable.dart';
import 'form_branch_entity.dart';
import 'form_deed_entity.dart';
import 'form_owner_entity.dart';
import 'option_value_label_entity.dart';
import 'property_form_step_entity.dart';

class PropertyFormOptionsEntity extends Equatable {
  final List<FormBranchEntity> branches;
  final List<FormOwnerEntity> owners;
  final List<FormDeedEntity> deeds;
  final List<OptionValueLabelEntity> propertyTypes;
  final List<OptionValueLabelEntity> usageTypes;
  final List<OptionValueLabelEntity> documentTypes;
  final List<OptionValueLabelEntity> propertyStatuses;
  final List<OptionValueLabelEntity> unitTypes;
  final List<OptionValueLabelEntity> unitStatuses;
  final List<OptionValueLabelEntity> unitPurposes;

  const PropertyFormOptionsEntity({
    required this.branches,
    required this.owners,
    required this.deeds,
    required this.propertyTypes,
    required this.usageTypes,
    required this.documentTypes,
    required this.propertyStatuses,
    required this.unitTypes,
    required this.unitStatuses,
    required this.unitPurposes,
  });

  @override
  List<Object?> get props => [
        branches,
        owners,
        deeds,
        propertyTypes,
        usageTypes,
        documentTypes,
        propertyStatuses,
        unitTypes,
        unitStatuses,
        unitPurposes,
      ];
}

class PropertyFormDefaultsEntity extends Equatable {
  final int? defaultOwnerId;
  final String? defaultOwnerName;
  final num? defaultOwnerPercentage;
  final bool isRepresentative;
  final String? defaultPropertyStatus;
  final String? defaultPropertyType;
  final String? defaultUnitStatus;

  const PropertyFormDefaultsEntity({
    this.defaultOwnerId,
    this.defaultOwnerName,
    this.defaultOwnerPercentage,
    this.isRepresentative = true,
    this.defaultPropertyStatus,
    this.defaultPropertyType,
    this.defaultUnitStatus,
  });

  @override
  List<Object?> get props => [
        defaultOwnerId,
        defaultOwnerName,
        defaultOwnerPercentage,
        isRepresentative,
        defaultPropertyStatus,
        defaultPropertyType,
        defaultUnitStatus,
      ];
}

class PropertyFormDataEntity extends Equatable {
  final List<PropertyFormStepEntity> steps;
  final PropertyFormOptionsEntity options;
  final PropertyFormDefaultsEntity defaults;
  final Map<String, String> endpoints;

  const PropertyFormDataEntity({
    required this.steps,
    required this.options,
    required this.defaults,
    required this.endpoints,
  });

  @override
  List<Object?> get props => [steps, options, defaults, endpoints];
}
