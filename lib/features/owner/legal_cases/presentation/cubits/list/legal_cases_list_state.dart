import 'package:equatable/equatable.dart';
import '../../../../../../core/utils/app_page_status.dart';
import '../../../../../../core/utils/app_page_state_mixin.dart';
import '../../../domain/entities/legal_case_item_entity.dart';
import '../../../domain/entities/legal_cases_filter_params.dart';
import '../../../domain/entities/legal_cases_list_response_entity.dart';

class LegalCasesListState extends Equatable with AppPageStateMixin {
  @override
  final AppPageStatus status;
  final List<LegalCaseItemEntity> legalCases;
  final LegalCasesFilterParams filterParams;
  final LegalCasePaginationEntity? pagination;
  final LegalCaseFiltersEntity? filters;
  final LegalCaseStatsEntity? stats;
  final bool isLoadingNextPage;
  final bool hasReachedMax;
  final String? errorMessage;

  const LegalCasesListState({
    this.status = AppPageStatus.initial,
    this.legalCases = const [],
    this.filterParams = const LegalCasesFilterParams(),
    this.pagination,
    this.filters,
    this.stats,
    this.isLoadingNextPage = false,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  LegalCasesListState copyWith({
    AppPageStatus? status,
    List<LegalCaseItemEntity>? legalCases,
    LegalCasesFilterParams? filterParams,
    LegalCasePaginationEntity? pagination,
    LegalCaseFiltersEntity? filters,
    LegalCaseStatsEntity? stats,
    bool? isLoadingNextPage,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return LegalCasesListState(
      status: status ?? this.status,
      legalCases: legalCases ?? this.legalCases,
      filterParams: filterParams ?? this.filterParams,
      pagination: pagination ?? this.pagination,
      filters: filters ?? this.filters,
      stats: stats ?? this.stats,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        legalCases,
        filterParams,
        pagination,
        filters,
        stats,
        isLoadingNextPage,
        hasReachedMax,
        errorMessage,
      ];
}
