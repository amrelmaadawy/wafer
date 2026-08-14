import 'package:equatable/equatable.dart';

class LegalCasesReportEntity extends Equatable {
  final LegalCasesSummaryEntity summary;
  final List<LegalCaseItemEntity> items;
  final Map<String, dynamic> pagination;
  final LegalCasesFilterOptionsEntity filterOptions;

  const LegalCasesReportEntity({
    required this.summary,
    required this.items,
    required this.pagination,
    required this.filterOptions,
  });

  @override
  List<Object?> get props => [summary, items, pagination, filterOptions];
}

class LegalCasesSummaryEntity extends Equatable {
  final int total;
  final int active;
  final int resolved;

  const LegalCasesSummaryEntity({
    required this.total,
    required this.active,
    required this.resolved,
  });

  @override
  List<Object?> get props => [total, active, resolved];
}

class LegalCaseItemEntity extends Equatable {
  final int id;
  final String caseNumber;
  final String? plaintiff;
  final String? defendant;
  final String? court;
  final String? hearingDate;
  final String? nextHearingDate;
  final String status;
  final String createdAt;

  // Relations mapped as basic properties to simplify UI usage
  final String? propertyName;
  final String? unitName;
  final String? contractNumber;
  final String? renterName;

  const LegalCaseItemEntity({
    required this.id,
    required this.caseNumber,
    this.plaintiff,
    this.defendant,
    this.court,
    this.hearingDate,
    this.nextHearingDate,
    required this.status,
    required this.createdAt,
    this.propertyName,
    this.unitName,
    this.contractNumber,
    this.renterName,
  });

  @override
  List<Object?> get props => [
    id,
    caseNumber,
    plaintiff,
    defendant,
    court,
    hearingDate,
    nextHearingDate,
    status,
    createdAt,
    propertyName,
    unitName,
    contractNumber,
    renterName,
  ];
}

class LegalCasesFilterOptionsEntity extends Equatable {
  final List<LegalCasesStatusFilterEntity> statuses;

  const LegalCasesFilterOptionsEntity({required this.statuses});

  @override
  List<Object?> get props => [statuses];
}

class LegalCasesStatusFilterEntity extends Equatable {
  final String value;
  final String label;

  const LegalCasesStatusFilterEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}
