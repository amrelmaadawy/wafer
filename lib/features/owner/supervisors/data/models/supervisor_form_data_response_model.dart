import '../../domain/entities/supervisor_form_data_entity.dart';

class SupervisorFormDataResponseModel extends SupervisorFormDataEntity {
  const SupervisorFormDataResponseModel({
    required super.users,
    required super.scopeTypes,
    required super.scopeValues,
    required super.scopeConditions,
    required super.booleanValues,
    required super.defaults,
    required super.validation,
  });

  factory SupervisorFormDataResponseModel.fromJson(Map<String, dynamic> json) {
    final options = json['options'] as Map<String, dynamic>? ?? {};
    
    // Parse users
    final usersList = (options['users'] as List<dynamic>?)
            ?.map((e) => SupervisorUserModel.fromJson(e))
            .toList() ??
        [];

    // Parse scopeTypes
    final scopeTypesList = (options['scope_types'] as List<dynamic>?)
            ?.map((e) => SupervisorScopeTypeModel.fromJson(e))
            .toList() ??
        [];

    // Parse scopeValues
    final scopeValuesMap = <String, List<SupervisorScopeValueModel>>{};
    if (options['scope_values'] is Map<String, dynamic>) {
      (options['scope_values'] as Map<String, dynamic>).forEach((key, value) {
        if (value is List<dynamic>) {
          scopeValuesMap[key] =
              value.map((e) => SupervisorScopeValueModel.fromJson(e)).toList();
        }
      });
    }

    // Parse scopeConditions
    final scopeConditionsList = (options['scope_conditions'] as List<dynamic>?)
            ?.map((e) => SupervisorScopeConditionModel.fromJson(e))
            .toList() ??
        [];

    // Parse booleanValues
    final booleanValuesList = (options['boolean_values'] as List<dynamic>?)
            ?.map((e) => SupervisorBooleanValueModel.fromJson(e))
            .toList() ??
        [];

    return SupervisorFormDataResponseModel(
      users: usersList,
      scopeTypes: scopeTypesList,
      scopeValues: scopeValuesMap,
      scopeConditions: scopeConditionsList,
      booleanValues: booleanValuesList,
      defaults: SupervisorFormDefaultsModel.fromJson(
          json['defaults'] as Map<String, dynamic>? ?? {}),
      validation: SupervisorFormValidationModel.fromJson(
          json['validation'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class SupervisorUserModel extends SupervisorUserEntity {
  const SupervisorUserModel({
    required super.id,
    super.name,
    super.email,
    super.phone,
    super.userType,
  });

  factory SupervisorUserModel.fromJson(Map<String, dynamic> json) {
    return SupervisorUserModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      userType: json['user_type'] as String?,
    );
  }
}

class SupervisorScopeTypeModel extends SupervisorScopeTypeEntity {
  const SupervisorScopeTypeModel({
    required super.value,
    required super.label,
  });

  factory SupervisorScopeTypeModel.fromJson(Map<String, dynamic> json) {
    return SupervisorScopeTypeModel(
      value: json['value'] as String,
      label: json['label'] as String,
    );
  }
}

class SupervisorScopeValueModel extends SupervisorScopeValueEntity {
  const SupervisorScopeValueModel({
    required super.id,
    super.name,
    super.code,
    super.email,
    super.phone,
  });

  factory SupervisorScopeValueModel.fromJson(Map<String, dynamic> json) {
    return SupervisorScopeValueModel(
      id: json['id'],
      name: json['name'] as String?,
      code: json['code'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }
}

class SupervisorScopeConditionModel extends SupervisorScopeConditionEntity {
  const SupervisorScopeConditionModel({
    required super.value,
    required super.label,
  });

  factory SupervisorScopeConditionModel.fromJson(Map<String, dynamic> json) {
    return SupervisorScopeConditionModel(
      value: json['value'] as String,
      label: json['label'] as String,
    );
  }
}

class SupervisorBooleanValueModel extends SupervisorBooleanValueEntity {
  const SupervisorBooleanValueModel({
    required super.value,
    required super.label,
  });

  factory SupervisorBooleanValueModel.fromJson(Map<String, dynamic> json) {
    return SupervisorBooleanValueModel(
      value: json['value'] as bool,
      label: json['label'] as String,
    );
  }
}

class SupervisorFormDefaultsModel extends SupervisorFormDefaultsEntity {
  const SupervisorFormDefaultsModel({
    super.scopeType,
    super.scopeCondition,
    super.scopeValues,
    super.sortOrder,
    super.isActive,
  });

  factory SupervisorFormDefaultsModel.fromJson(Map<String, dynamic> json) {
    return SupervisorFormDefaultsModel(
      scopeType: json['scope_type'] as String?,
      scopeCondition: json['scope_condition'] as String?,
      scopeValues: json['scope_values'] as List<dynamic>?,
      sortOrder: json['sort_order'] as int?,
      isActive: json['is_active'] as bool?,
    );
  }
}

class SupervisorFormValidationModel extends SupervisorFormValidationEntity {
  const SupervisorFormValidationModel({
    required super.requiredFields,
    required super.scopeTypeRequiresValues,
  });

  factory SupervisorFormValidationModel.fromJson(Map<String, dynamic> json) {
    return SupervisorFormValidationModel(
      requiredFields: (json['required'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      scopeTypeRequiresValues:
          (json['scope_type_requires_values'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
    );
  }
}
