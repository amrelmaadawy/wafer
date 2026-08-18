import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failure_extensions.dart';
import '../../../../../../core/utils/app_page_status.dart';
import '../../../domain/entities/legal_case_item_entity.dart';
import '../../../domain/usecases/get_legal_cases_list_use_case.dart';
import 'legal_cases_list_state.dart';

class LegalCasesListCubit extends Cubit<LegalCasesListState> {
  final GetLegalCasesListUseCase getLegalCasesListUseCase;

  LegalCasesListCubit({required this.getLegalCasesListUseCase})
      : super(const LegalCasesListState());

  bool _isFetching = false;

  Future<void> fetchLegalCases({bool refresh = false, bool isLoadMore = false}) async {
    if (_isFetching) return;
    if (isLoadMore && (state.hasReachedMax || state.isLoadingNextPage)) return;

    _isFetching = true;

    if (refresh) {
      emit(state.copyWith(
        status: state.legalCases.isEmpty ? AppPageStatus.loading : AppPageStatus.refreshing,
        filterParams: state.filterParams.copyWith(page: 1),
        hasReachedMax: false,
        isLoadingNextPage: false,
      ));
    } else if (isLoadMore) {
      emit(state.copyWith(isLoadingNextPage: true));
    } else if (state.status == AppPageStatus.initial) {
      emit(state.copyWith(status: AppPageStatus.loading));
    }

    try {
      final currentParams = refresh
          ? state.filterParams.copyWith(page: 1)
          : state.filterParams;

      final result = await getLegalCasesListUseCase(currentParams);

      result.fold(
        (failure) {
          emit(state.copyWith(
            status: isLoadMore ? state.status : failure.toPageStatus(),
            isLoadingNextPage: false,
            errorMessage: failure.message,
          ));
        },
        (response) {
          final List<LegalCaseItemEntity> newCases = response.legalCases ?? [];
          final pagination = response.pagination;
          final hasReachedMax = newCases.isEmpty ||
              (pagination?.currentPage == pagination?.lastPage);
          final updatedCases = refresh || currentParams.page == 1
              ? newCases
              : [...state.legalCases, ...newCases];

          emit(state.copyWith(
            status: updatedCases.isEmpty ? AppPageStatus.empty : AppPageStatus.success,
            legalCases: updatedCases,
            pagination: pagination,
            filters: response.filters,
            stats: response.stats,
            filterParams: currentParams.copyWith(page: currentParams.page + 1),
            isLoadingNextPage: false,
            hasReachedMax: hasReachedMax,
          ));
        },
      );
    } finally {
      _isFetching = false;
    }
  }

  void search(String query) {
    if (state.filterParams.search == query) return;
    emit(state.copyWith(
      filterParams: state.filterParams.copyWith(
        search: query.isEmpty ? null : query,
        clearSearch: query.isEmpty,
        page: 1,
      ),
    ));
    fetchLegalCases(refresh: true);
  }

  void filterByStatus(String? status) {
    if (state.filterParams.status == status) return;
    emit(state.copyWith(
      filterParams: state.filterParams.copyWith(
        status: status,
        clearStatus: status == null,
        page: 1,
      ),
    ));
    fetchLegalCases(refresh: true);
  }

  void filterByCategory(String? caseType) {
    if (state.filterParams.caseType == caseType) return;
    emit(state.copyWith(
      filterParams: state.filterParams.copyWith(
        caseType: caseType,
        clearCaseType: caseType == null,
        page: 1,
      ),
    ));
    fetchLegalCases(refresh: true);
  }

  void filterByPriority(String? priority) {
    if (state.filterParams.priority == priority) return;
    emit(state.copyWith(
      filterParams: state.filterParams.copyWith(
        priority: priority,
        clearPriority: priority == null,
        page: 1,
      ),
    ));
    fetchLegalCases(refresh: true);
  }

  void filterByDates({String? from, String? to}) {
    emit(state.copyWith(
      filterParams: state.filterParams.copyWith(
        dateFrom: from,
        dateTo: to,
        clearDates: from == null && to == null,
        page: 1,
      ),
    ));
    fetchLegalCases(refresh: true);
  }
}
