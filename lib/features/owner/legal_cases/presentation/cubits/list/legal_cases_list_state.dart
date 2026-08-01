import 'package:equatable/equatable.dart';
import '../../../domain/entities/legal_case_item_entity.dart';
import '../../../domain/entities/legal_cases_list_response_entity.dart';

abstract class LegalCasesListState extends Equatable {
  const LegalCasesListState();

  @override
  List<Object?> get props => [];
}

class LegalCasesListInitial extends LegalCasesListState {}

class LegalCasesListLoading extends LegalCasesListState {
  final bool isFirstFetch;

  const LegalCasesListLoading({this.isFirstFetch = false});

  @override
  List<Object?> get props => [isFirstFetch];
}

class LegalCasesListLoaded extends LegalCasesListState {
  final List<LegalCaseItemEntity> legalCases;
  final LegalCasePaginationEntity? pagination;
  final LegalCaseFiltersEntity? filters;
  final LegalCaseStatsEntity? stats;
  final bool hasReachedMax;

  const LegalCasesListLoaded({
    required this.legalCases,
    this.pagination,
    this.filters,
    this.stats,
    this.hasReachedMax = false,
  });

  LegalCasesListLoaded copyWith({
    List<LegalCaseItemEntity>? legalCases,
    LegalCasePaginationEntity? pagination,
    LegalCaseFiltersEntity? filters,
    LegalCaseStatsEntity? stats,
    bool? hasReachedMax,
  }) {
    return LegalCasesListLoaded(
      legalCases: legalCases ?? this.legalCases,
      pagination: pagination ?? this.pagination,
      filters: filters ?? this.filters,
      stats: stats ?? this.stats,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props =>
      [legalCases, pagination, filters, stats, hasReachedMax];
}

class LegalCasesListError extends LegalCasesListState {
  final String message;

  const LegalCasesListError({required this.message});

  @override
  List<Object?> get props => [message];
}
