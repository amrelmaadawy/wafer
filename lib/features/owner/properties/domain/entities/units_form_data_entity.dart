import 'package:equatable/equatable.dart';
import 'form_branch_entity.dart';
import 'option_value_label_entity.dart';

class FormPropertyEntity extends Equatable {
  final int id;
  final String? name;
  final String code;

  const FormPropertyEntity({
    required this.id,
    this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}

class UnitsFormOptionsEntity extends Equatable {
  final List<FormPropertyEntity> properties;
  final List<FormBranchEntity> branches;
  final List<OptionValueLabelEntity> unitTypes;
  final List<OptionValueLabelEntity> unitStatuses;
  final List<OptionValueLabelEntity> unitPurposes;
  final List<OptionValueLabelEntity> usageTypes;
  final List<OptionValueLabelEntity> booleanValues;

  const UnitsFormOptionsEntity({
    required this.properties,
    required this.branches,
    required this.unitTypes,
    required this.unitStatuses,
    required this.unitPurposes,
    required this.usageTypes,
    required this.booleanValues,
  });

  @override
  List<Object?> get props => [
        properties,
        branches,
        unitTypes,
        unitStatuses,
        unitPurposes,
        usageTypes,
        booleanValues,
      ];
}

class UnitsFormDataEntity extends Equatable {
  final UnitsFormOptionsEntity options;

  const UnitsFormDataEntity({
    required this.options,
  });

  @override
  List<Object?> get props => [options];
}
