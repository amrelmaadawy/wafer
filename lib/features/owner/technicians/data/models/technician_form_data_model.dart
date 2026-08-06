import '../../domain/entities/technician_form_data_entity.dart';

class TechnicianFormDataModel extends TechnicianFormDataEntity {
  const TechnicianFormDataModel({
    required super.options,
    required super.defaults,
    required super.validation,
  });

  factory TechnicianFormDataModel.fromJson(Map<String, dynamic> json) {
    return TechnicianFormDataModel(
      options: TechnicianFormOptionsModel.fromJson(
        json['options'] as Map<String, dynamic>? ?? {},
      ),
      defaults: TechnicianFormDefaultsModel.fromJson(
        json['defaults'] as Map<String, dynamic>? ?? {},
      ),
      validation: TechnicianFormValidationModel.fromJson(
        json['validation'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class TechnicianFormOptionsModel extends TechnicianFormOptionsEntity {
  const TechnicianFormOptionsModel({
    required super.specialties,
    required super.companies,
    required super.booleanValues,
  });

  factory TechnicianFormOptionsModel.fromJson(Map<String, dynamic> json) {
    return TechnicianFormOptionsModel(
      specialties:
          (json['specialties'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      companies:
          (json['companies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      booleanValues:
          (json['boolean_values'] as List<dynamic>?)
              ?.map(
                (e) => TechnicianBooleanValueModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

class TechnicianBooleanValueModel extends TechnicianBooleanValueEntity {
  const TechnicianBooleanValueModel({
    required super.value,
    required super.label,
  });

  factory TechnicianBooleanValueModel.fromJson(Map<String, dynamic> json) {
    return TechnicianBooleanValueModel(
      value: json['value'] as bool? ?? false,
      label: json['label'] as String? ?? '',
    );
  }
}

class TechnicianFormDefaultsModel extends TechnicianFormDefaultsEntity {
  const TechnicianFormDefaultsModel({
    required super.ownerId,
    required super.isActive,
  });

  factory TechnicianFormDefaultsModel.fromJson(Map<String, dynamic> json) {
    return TechnicianFormDefaultsModel(
      ownerId: json['owner_id'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

class TechnicianFormValidationModel extends TechnicianFormValidationEntity {
  const TechnicianFormValidationModel({
    required super.requiredFields,
    required super.name,
    required super.phone,
    required super.specialty,
    required super.companyName,
  });

  factory TechnicianFormValidationModel.fromJson(Map<String, dynamic> json) {
    return TechnicianFormValidationModel(
      requiredFields:
          (json['required'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      name: json['name'] as Map<String, dynamic>? ?? {},
      phone: json['phone'] as Map<String, dynamic>? ?? {},
      specialty: json['specialty'] as Map<String, dynamic>? ?? {},
      companyName: json['company_name'] as Map<String, dynamic>? ?? {},
    );
  }
}
