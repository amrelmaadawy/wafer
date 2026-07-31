import 'package:equatable/equatable.dart';

class TechnicianFormDataEntity extends Equatable {
  final TechnicianFormOptionsEntity options;
  final TechnicianFormDefaultsEntity defaults;
  final TechnicianFormValidationEntity validation;

  const TechnicianFormDataEntity({
    required this.options,
    required this.defaults,
    required this.validation,
  });

  @override
  List<Object?> get props => [options, defaults, validation];
}

class TechnicianFormOptionsEntity extends Equatable {
  final List<String> specialties;
  final List<String> companies;
  final List<TechnicianBooleanValueEntity> booleanValues;

  const TechnicianFormOptionsEntity({
    required this.specialties,
    required this.companies,
    required this.booleanValues,
  });

  @override
  List<Object?> get props => [specialties, companies, booleanValues];
}

class TechnicianBooleanValueEntity extends Equatable {
  final bool value;
  final String label;

  const TechnicianBooleanValueEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}

class TechnicianFormDefaultsEntity extends Equatable {
  final int ownerId;
  final bool isActive;

  const TechnicianFormDefaultsEntity({
    required this.ownerId,
    required this.isActive,
  });

  @override
  List<Object?> get props => [ownerId, isActive];
}

class TechnicianFormValidationEntity extends Equatable {
  final List<String> requiredFields;
  final Map<String, dynamic> name;
  final Map<String, dynamic> phone;
  final Map<String, dynamic> specialty;
  final Map<String, dynamic> companyName;

  const TechnicianFormValidationEntity({
    required this.requiredFields,
    required this.name,
    required this.phone,
    required this.specialty,
    required this.companyName,
  });

  @override
  List<Object?> get props => [
        requiredFields,
        name,
        phone,
        specialty,
        companyName,
      ];
}
