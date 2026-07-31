import 'package:equatable/equatable.dart';

class SupervisorFormDataEntity extends Equatable {
  final List<SupervisorUserEntity> users;
  final List<SupervisorScopeTypeEntity> scopeTypes;
  final Map<String, List<SupervisorScopeValueEntity>> scopeValues;
  final List<SupervisorScopeConditionEntity> scopeConditions;
  final List<SupervisorBooleanValueEntity> booleanValues;
  final SupervisorFormDefaultsEntity defaults;
  final SupervisorFormValidationEntity validation;

  const SupervisorFormDataEntity({
    required this.users,
    required this.scopeTypes,
    required this.scopeValues,
    required this.scopeConditions,
    required this.booleanValues,
    required this.defaults,
    required this.validation,
  });

  @override
  List<Object?> get props => [
        users,
        scopeTypes,
        scopeValues,
        scopeConditions,
        booleanValues,
        defaults,
        validation,
      ];
}

class SupervisorUserEntity extends Equatable {
  final int id;
  final String? name;
  final String? email;
  final String? phone;
  final String? userType;

  const SupervisorUserEntity({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.userType,
  });

  @override
  List<Object?> get props => [id, name, email, phone, userType];
}

class SupervisorScopeTypeEntity extends Equatable {
  final String value;
  final String label;

  const SupervisorScopeTypeEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}

class SupervisorScopeValueEntity extends Equatable {
  final dynamic id; // can be int or string
  final String? name;
  final String? code;
  final String? email;
  final String? phone;

  const SupervisorScopeValueEntity({
    required this.id,
    this.name,
    this.code,
    this.email,
    this.phone,
  });

  @override
  List<Object?> get props => [id, name, code, email, phone];
}

class SupervisorScopeConditionEntity extends Equatable {
  final String value;
  final String label;

  const SupervisorScopeConditionEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}

class SupervisorBooleanValueEntity extends Equatable {
  final bool value;
  final String label;

  const SupervisorBooleanValueEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}

class SupervisorFormDefaultsEntity extends Equatable {
  final String? scopeType;
  final String? scopeCondition;
  final List<dynamic>? scopeValues;
  final int? sortOrder;
  final bool? isActive;

  const SupervisorFormDefaultsEntity({
    this.scopeType,
    this.scopeCondition,
    this.scopeValues,
    this.sortOrder,
    this.isActive,
  });

  @override
  List<Object?> get props => [
        scopeType,
        scopeCondition,
        scopeValues,
        sortOrder,
        isActive,
      ];
}

class SupervisorFormValidationEntity extends Equatable {
  final List<String> requiredFields;
  final List<String> scopeTypeRequiresValues;

  const SupervisorFormValidationEntity({
    required this.requiredFields,
    required this.scopeTypeRequiresValues,
  });

  @override
  List<Object?> get props => [requiredFields, scopeTypeRequiresValues];
}
