import '../../domain/entities/legal_cases_report_entity.dart';

class LegalCasesReportModel extends LegalCasesReportEntity {
  const LegalCasesReportModel({
    required super.summary,
    required super.items,
    required super.pagination,
    required super.filterOptions,
  });

  factory LegalCasesReportModel.fromJson(Map<String, dynamic> json) {
    return LegalCasesReportModel(
      summary: LegalCasesSummaryModel.fromJson(json['summary'] ?? {}),
      items:
          (json['items'] as List?)
              ?.map((e) => LegalCaseItemModel.fromJson(e))
              .toList() ??
          [],
      pagination: json['pagination'] ?? {},
      filterOptions: LegalCasesFilterOptionsModel.fromJson(
        json['filter_options'] ?? {},
      ),
    );
  }
}

class LegalCasesSummaryModel extends LegalCasesSummaryEntity {
  const LegalCasesSummaryModel({
    required super.total,
    required super.active,
    required super.resolved,
  });

  factory LegalCasesSummaryModel.fromJson(Map<String, dynamic> json) {
    return LegalCasesSummaryModel(
      total: json['total'] ?? 0,
      active: json['active'] ?? 0,
      resolved: json['resolved'] ?? 0,
    );
  }
}

class LegalCaseItemModel extends LegalCaseItemEntity {
  const LegalCaseItemModel({
    required super.id,
    required super.caseNumber,
    super.plaintiff,
    super.defendant,
    super.court,
    super.hearingDate,
    super.nextHearingDate,
    required super.status,
    required super.createdAt,
    super.propertyName,
    super.unitName,
    super.contractNumber,
    super.renterName,
  });

  factory LegalCaseItemModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseItemModel(
      id: json['id'] ?? 0,
      caseNumber: json['case_number'] ?? '',
      plaintiff: json['plaintiff'],
      defendant: json['defendant'],
      court: json['court'],
      hearingDate: json['hearing_date'],
      nextHearingDate: json['next_hearing_date'],
      status: json['status'] ?? 'Unknown',
      createdAt: json['created_at'] ?? '',
      propertyName: json['property']?['name'],
      unitName: json['unit']?['name'],
      contractNumber: json['contract']?['contract_number'],
      renterName: json['renter']?['name'],
    );
  }
}

class LegalCasesFilterOptionsModel extends LegalCasesFilterOptionsEntity {
  const LegalCasesFilterOptionsModel({required super.statuses});

  factory LegalCasesFilterOptionsModel.fromJson(Map<String, dynamic> json) {
    return LegalCasesFilterOptionsModel(
      statuses:
          (json['statuses'] as List?)
              ?.map((e) => LegalCasesStatusFilterModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class LegalCasesStatusFilterModel extends LegalCasesStatusFilterEntity {
  const LegalCasesStatusFilterModel({
    required super.value,
    required super.label,
  });

  factory LegalCasesStatusFilterModel.fromJson(Map<String, dynamic> json) {
    return LegalCasesStatusFilterModel(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }
}
