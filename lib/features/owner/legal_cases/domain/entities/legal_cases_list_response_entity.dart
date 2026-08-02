import 'package:equatable/equatable.dart';

import 'legal_case_item_entity.dart';

class LegalCasesListResponseEntity extends Equatable {
  final List<LegalCaseItemEntity>? legalCases;
  final LegalCasePaginationEntity? pagination;
  final LegalCaseFiltersEntity? filters;
  final LegalCaseStatsEntity? stats;

  const LegalCasesListResponseEntity({
    this.legalCases,
    this.pagination,
    this.filters,
    this.stats,
  });

  @override
  List<Object?> get props => [legalCases, pagination, filters, stats];
}

class LegalCasePaginationEntity extends Equatable {
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;
  final int? from;
  final int? to;

  const LegalCasePaginationEntity({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
  });

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total, from, to];
}

class LegalCaseFiltersEntity extends Equatable {
  final List<dynamic>? applied;
  final List<String>? supported;

  const LegalCaseFiltersEntity({this.applied, this.supported});

  @override
  List<Object?> get props => [applied, supported];
}

class LegalCaseStatsEntity extends Equatable {
  final int? total;
  final Map<String, int>? byStatus;

  const LegalCaseStatsEntity({this.total, this.byStatus});

  @override
  List<Object?> get props => [total, byStatus];
}
