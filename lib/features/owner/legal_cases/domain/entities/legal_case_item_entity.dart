import 'package:equatable/equatable.dart';

import 'legal_case_complex_sub_entities.dart';

class LegalCaseItemEntity extends Equatable {
  final int? id;
  final String? caseNumber;
  final String? caseType;
  final String? court;
  final String? circuit;
  final LegalCasePartiesEntity? parties;
  final LegalCaseLawyerEntity? lawyer;
  final String? status;
  final String? statusColor;
  final num? amount;
  final String? hearingDate;
  final String? notes;
  final LegalCaseBranchEntity? branch;
  final LegalCasePropertyEntity? property;
  final LegalCaseUnitEntity? unit;
  final LegalCaseContractEntity? contract;
  final int? invoiceId;
  final String? attachment;
  final LegalCaseStageEntity? latestStage;
  final List<LegalCaseStageEntity>? stages;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;

  const LegalCaseItemEntity({
    this.id,
    this.caseNumber,
    this.caseType,
    this.court,
    this.circuit,
    this.parties,
    this.lawyer,
    this.status,
    this.statusColor,
    this.amount,
    this.hearingDate,
    this.notes,
    this.branch,
    this.property,
    this.unit,
    this.contract,
    this.invoiceId,
    this.attachment,
    this.latestStage,
    this.stages,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        caseNumber,
        caseType,
        court,
        circuit,
        parties,
        lawyer,
        status,
        statusColor,
        amount,
        hearingDate,
        notes,
        branch,
        property,
        unit,
        contract,
        invoiceId,
        attachment,
        latestStage,
        stages,
        createdBy,
        createdAt,
        updatedAt,
      ];
}

class LegalCasePartiesEntity extends Equatable {
  final String? plaintiff;
  final String? defendant;

  const LegalCasePartiesEntity({this.plaintiff, this.defendant});

  @override
  List<Object?> get props => [plaintiff, defendant];
}

class LegalCaseLawyerEntity extends Equatable {
  final String? name;
  final String? phone;
  final String? office;

  const LegalCaseLawyerEntity({this.name, this.phone, this.office});

  @override
  List<Object?> get props => [name, phone, office];
}

class LegalCaseStageEntity extends Equatable {
  final int? id;
  final int? legalCaseId;
  final String? stageName;
  final String? stageNameDisplay;
  final String? stageColor;
  final String? stageIcon;
  final String? notes;
  final String? stageDate;
  final LegalCaseAttachmentEntity? attachment;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;

  const LegalCaseStageEntity({
    this.id,
    this.legalCaseId,
    this.stageName,
    this.stageNameDisplay,
    this.stageColor,
    this.stageIcon,
    this.notes,
    this.stageDate,
    this.attachment,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        legalCaseId,
        stageName,
        stageNameDisplay,
        stageColor,
        stageIcon,
        notes,
        stageDate,
        attachment,
        createdBy,
        createdAt,
        updatedAt,
      ];
}

class LegalCaseAttachmentEntity extends Equatable {
  final String? path;
  final String? url;

  const LegalCaseAttachmentEntity({this.path, this.url});

  @override
  List<Object?> get props => [path, url];
}
