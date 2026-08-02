import '../../domain/entities/legal_case_item_entity.dart';
import 'legal_case_complex_sub_models.dart';

class LegalCaseItemModel extends LegalCaseItemEntity {
  const LegalCaseItemModel({
    super.id,
    super.caseNumber,
    super.caseType,
    super.court,
    super.circuit,
    super.parties,
    super.lawyer,
    super.status,
    super.statusColor,
    super.amount,
    super.hearingDate,
    super.notes,
    super.branch,
    super.property,
    super.unit,
    super.contract,
    super.invoiceId,
    super.attachment,
    super.latestStage,
    super.stages,
    super.createdBy,
    super.createdAt,
    super.updatedAt,
  });

  factory LegalCaseItemModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseItemModel(
      id: json['id'] as int?,
      caseNumber: json['case_number'] as String?,
      caseType: json['case_type'] as String?,
      court: json['court'] as String?,
      circuit: json['circuit'] as String?,
      parties: (json['parties'] != null && json['parties'] is Map)
          ? LegalCasePartiesModel.fromJson(json['parties'])
          : null,
      lawyer: (json['lawyer'] != null && json['lawyer'] is Map)
          ? LegalCaseLawyerModel.fromJson(json['lawyer'])
          : null,
      status: json['status'] as String?,
      statusColor: json['status_color'] as String?,
      amount: json['amount'] as num?,
      hearingDate: json['hearing_date'] as String?,
      notes: json['notes'] as String?,
      branch: (json['branch'] != null && json['branch'] is Map)
          ? LegalCaseBranchModel.fromJson(json['branch'])
          : null,
      property: (json['property'] != null && json['property'] is Map)
          ? LegalCasePropertyModel.fromJson(json['property'])
          : null,
      unit: (json['unit'] != null && json['unit'] is Map)
          ? LegalCaseUnitModel.fromJson(json['unit'])
          : null,
      contract: (json['contract'] != null && json['contract'] is Map)
          ? LegalCaseContractModel.fromJson(json['contract'])
          : null,
      invoiceId: json['invoice_id'] as int?,
      attachment: json['attachment']
          ?.toString(), // Handle attachment string or object if needed
      latestStage: (json['latest_stage'] != null && json['latest_stage'] is Map)
          ? LegalCaseStageModel.fromJson(json['latest_stage'])
          : null,
      stages: (json['stages'] != null && json['stages'] is List)
          ? (json['stages'] as List)
                .map((e) => LegalCaseStageModel.fromJson(e))
                .toList()
          : null,
      createdBy: json['created_by'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

class LegalCasePartiesModel extends LegalCasePartiesEntity {
  const LegalCasePartiesModel({super.plaintiff, super.defendant});

  factory LegalCasePartiesModel.fromJson(Map<String, dynamic> json) {
    return LegalCasePartiesModel(
      plaintiff: json['plaintiff'] as String?,
      defendant: json['defendant'] as String?,
    );
  }
}

class LegalCaseLawyerModel extends LegalCaseLawyerEntity {
  const LegalCaseLawyerModel({super.name, super.phone, super.office});

  factory LegalCaseLawyerModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseLawyerModel(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      office: json['office'] as String?,
    );
  }
}

class LegalCaseStageModel extends LegalCaseStageEntity {
  const LegalCaseStageModel({
    super.id,
    super.legalCaseId,
    super.stageName,
    super.stageNameDisplay,
    super.stageColor,
    super.stageIcon,
    super.notes,
    super.stageDate,
    super.attachment,
    super.createdBy,
    super.createdAt,
    super.updatedAt,
  });

  factory LegalCaseStageModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseStageModel(
      id: json['id'] as int?,
      legalCaseId: json['legal_case_id'] as int?,
      stageName: json['stage_name'] as String?,
      stageNameDisplay: json['stage_name_display'] as String?,
      stageColor: json['stage_color'] as String?,
      stageIcon: json['stage_icon'] as String?,
      notes: json['notes'] as String?,
      stageDate: json['stage_date'] as String?,
      attachment: json['attachment'] is Map<String, dynamic>
          ? LegalCaseAttachmentModel.fromJson(json['attachment'])
          : (json['attachment'] is String
                ? LegalCaseAttachmentModel(url: json['attachment'] as String)
                : null),
      createdBy: json['created_by'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

class LegalCaseAttachmentModel extends LegalCaseAttachmentEntity {
  const LegalCaseAttachmentModel({super.path, super.url});

  factory LegalCaseAttachmentModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseAttachmentModel(
      path: json['path'] as String?,
      url: json['url'] as String?,
    );
  }
}
