import '../../domain/entities/legal_case_form_data_entity.dart';
import 'legal_case_complex_sub_models.dart';

class LegalCaseFormDataModel extends LegalCaseFormDataEntity {
  const LegalCaseFormDataModel({
    super.options,
    super.defaults,
    super.validation,
  });

  factory LegalCaseFormDataModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseFormDataModel(
      options: json['options'] != null
          ? LegalCaseOptionsModel.fromJson(json['options'])
          : null,
      defaults: json['defaults'] != null
          ? LegalCaseDefaultsModel.fromJson(json['defaults'])
          : null,
      validation: json['validation'] != null
          ? LegalCaseValidationModel.fromJson(json['validation'])
          : null,
    );
  }
}

class LegalCaseOptionsModel extends LegalCaseOptionsEntity {
  const LegalCaseOptionsModel({
    super.properties,
    super.units,
    super.contracts,
    super.invoices,
    super.branches,
    super.statuses,
    super.stages,
    super.caseTypes,
    super.courts,
    super.circuits,
    super.plaintiffs,
    super.defendants,
    super.lawyers,
    super.lawyerOffices,
  });

  factory LegalCaseOptionsModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseOptionsModel(
      properties: json['properties'] != null
          ? (json['properties'] as List)
              .map((e) => LegalCasePropertyModel.fromJson(e))
              .toList()
          : null,
      units: json['units'] != null
          ? (json['units'] as List)
              .map((e) => LegalCaseUnitModel.fromJson(e))
              .toList()
          : null,
      contracts: json['contracts'] != null
          ? (json['contracts'] as List)
              .map((e) => LegalCaseContractModel.fromJson(e))
              .toList()
          : null,
      invoices: json['invoices'] != null
          ? (json['invoices'] as List)
              .map((e) => LegalCaseInvoiceModel.fromJson(e))
              .toList()
          : null,
      branches: json['branches'] != null
          ? (json['branches'] as List)
              .map((e) => LegalCaseBranchModel.fromJson(e))
              .toList()
          : null,
      statuses: json['statuses'] != null
          ? (json['statuses'] as List)
              .map((e) => LegalCaseOptionModel.fromJson(e))
              .toList()
          : null,
      stages: json['stages'] != null
          ? (json['stages'] as List)
              .map((e) => LegalCaseOptionModel.fromJson(e))
              .toList()
          : null,
      caseTypes: json['case_types'] != null
          ? (json['case_types'] as List)
              .map((e) => LegalCaseOptionModel.fromJson(e))
              .toList()
          : null,
      courts: json['courts'] != null
          ? (json['courts'] as List)
              .map((e) => LegalCaseOptionModel.fromJson(e))
              .toList()
          : null,
      circuits: json['circuits'] != null
          ? (json['circuits'] as List)
              .map((e) => LegalCaseOptionModel.fromJson(e))
              .toList()
          : null,
      plaintiffs: json['plaintiffs'] != null
          ? (json['plaintiffs'] as List)
              .map((e) => LegalCaseOptionModel.fromJson(e))
              .toList()
          : null,
      defendants: json['defendants'] != null
          ? (json['defendants'] as List)
              .map((e) => LegalCaseOptionModel.fromJson(e))
              .toList()
          : null,
      lawyers: json['lawyers'] != null
          ? (json['lawyers'] as List)
              .map((e) => LegalCaseOptionModel.fromJson(e))
              .toList()
          : null,
      lawyerOffices: json['lawyer_offices'] != null
          ? (json['lawyer_offices'] as List)
              .map((e) => LegalCaseOptionModel.fromJson(e))
              .toList()
          : null,
    );
  }
}

class LegalCaseDefaultsModel extends LegalCaseDefaultsEntity {
  const LegalCaseDefaultsModel({
    super.caseNumber,
    super.status,
    super.amount,
    super.hearingDate,
  });

  factory LegalCaseDefaultsModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseDefaultsModel(
      caseNumber: json['case_number'] as String?,
      status: json['status'] as String?,
      amount: json['amount'] as num?,
      hearingDate: json['hearing_date'] as String?,
    );
  }
}

class LegalCaseValidationModel extends LegalCaseValidationEntity {
  const LegalCaseValidationModel({
    super.requiredFields,
    super.attachment,
  });

  factory LegalCaseValidationModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseValidationModel(
      requiredFields: json['required'] != null
          ? (json['required'] as List).map((e) => e.toString()).toList()
          : null,
      attachment: json['attachment'] != null
          ? LegalCaseAttachmentValidationModel.fromJson(json['attachment'])
          : null,
    );
  }
}

class LegalCaseAttachmentValidationModel
    extends LegalCaseAttachmentValidationEntity {
  const LegalCaseAttachmentValidationModel({
    super.mimes,
    super.maxKb,
  });

  factory LegalCaseAttachmentValidationModel.fromJson(
      Map<String, dynamic> json) {
    return LegalCaseAttachmentValidationModel(
      mimes: json['mimes'] != null
          ? (json['mimes'] as List).map((e) => e.toString()).toList()
          : null,
      maxKb: json['max_kb'] as int?,
    );
  }
}
