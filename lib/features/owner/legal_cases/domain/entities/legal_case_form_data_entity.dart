import 'package:equatable/equatable.dart';

import 'legal_case_complex_sub_entities.dart';

class LegalCaseFormDataEntity extends Equatable {
  final LegalCaseOptionsEntity? options;
  final LegalCaseDefaultsEntity? defaults;
  final LegalCaseValidationEntity? validation;

  const LegalCaseFormDataEntity({
    this.options,
    this.defaults,
    this.validation,
  });

  @override
  List<Object?> get props => [options, defaults, validation];
}

class LegalCaseOptionsEntity extends Equatable {
  final List<LegalCasePropertyEntity>? properties;
  final List<LegalCaseUnitEntity>? units;
  final List<LegalCaseContractEntity>? contracts;
  final List<LegalCaseInvoiceEntity>? invoices;
  final List<LegalCaseBranchEntity>? branches;
  final List<LegalCaseOptionEntity>? statuses;
  final List<LegalCaseOptionEntity>? stages;
  final List<LegalCaseOptionEntity>? caseTypes;
  final List<LegalCaseOptionEntity>? courts;
  final List<LegalCaseOptionEntity>? circuits;
  final List<LegalCaseOptionEntity>? plaintiffs;
  final List<LegalCaseOptionEntity>? defendants;
  final List<LegalCaseOptionEntity>? lawyers;
  final List<LegalCaseOptionEntity>? lawyerOffices;

  const LegalCaseOptionsEntity({
    this.properties,
    this.units,
    this.contracts,
    this.invoices,
    this.branches,
    this.statuses,
    this.stages,
    this.caseTypes,
    this.courts,
    this.circuits,
    this.plaintiffs,
    this.defendants,
    this.lawyers,
    this.lawyerOffices,
  });

  @override
  List<Object?> get props => [
        properties,
        units,
        contracts,
        invoices,
        branches,
        statuses,
        stages,
        caseTypes,
        courts,
        circuits,
        plaintiffs,
        defendants,
        lawyers,
        lawyerOffices,
      ];
}

class LegalCaseDefaultsEntity extends Equatable {
  final String? caseNumber;
  final String? status;
  final num? amount;
  final String? hearingDate;

  const LegalCaseDefaultsEntity({
    this.caseNumber,
    this.status,
    this.amount,
    this.hearingDate,
  });

  @override
  List<Object?> get props => [caseNumber, status, amount, hearingDate];
}

class LegalCaseValidationEntity extends Equatable {
  final List<String>? requiredFields;
  final LegalCaseAttachmentValidationEntity? attachment;

  const LegalCaseValidationEntity({
    this.requiredFields,
    this.attachment,
  });

  @override
  List<Object?> get props => [requiredFields, attachment];
}

class LegalCaseAttachmentValidationEntity extends Equatable {
  final List<String>? mimes;
  final int? maxKb;

  const LegalCaseAttachmentValidationEntity({
    this.mimes,
    this.maxKb,
  });

  @override
  List<Object?> get props => [mimes, maxKb];
}
