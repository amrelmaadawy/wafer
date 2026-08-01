import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/legal_case_item_entity.dart';
import '../../../domain/usecases/get_legal_cases_list_use_case.dart';
import 'legal_cases_list_state.dart';

class LegalCasesListCubit extends Cubit<LegalCasesListState> {
  final GetLegalCasesListUseCase getLegalCasesListUseCase;

  LegalCasesListCubit({required this.getLegalCasesListUseCase})
      : super(LegalCasesListInitial());

  int _currentPage = 1;
  bool _isFetching = false;
  String? _currentStatus;

  Future<void> fetchLegalCases({String? status, bool isRefresh = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    if (isRefresh || status != _currentStatus) {
      _currentPage = 1;
      _currentStatus = status;
      emit(const LegalCasesListLoading(isFirstFetch: true));
    } else {
      if (state is LegalCasesListLoaded &&
          (state as LegalCasesListLoaded).hasReachedMax) {
        _isFetching = false;
        return;
      }
      emit(LegalCasesListLoading(isFirstFetch: _currentPage == 1));
    }

    final result = await getLegalCasesListUseCase(
      GetLegalCasesListParams(
        page: _currentPage,
        perPage: 15,
        status: _currentStatus,
      ),
    );

    result.fold(
      (failure) {
        emit(LegalCasesListError(message: failure.message));
        _isFetching = false;
      },
      (response) {
        final List<LegalCaseItemEntity> newCases = response.legalCases ?? [];
        final hasReachedMax =
            newCases.isEmpty || (response.pagination?.currentPage == response.pagination?.lastPage);

        if (_currentPage == 1) {
          emit(LegalCasesListLoaded(
            legalCases: newCases,
            pagination: response.pagination,
            filters: response.filters,
            stats: response.stats,
            hasReachedMax: hasReachedMax,
          ));
        } else {
          final currentState = state as LegalCasesListLoaded;
          emit(currentState.copyWith(
            legalCases: currentState.legalCases + newCases,
            pagination: response.pagination,
            hasReachedMax: hasReachedMax,
          ));
        }
        
        if (!hasReachedMax) {
          _currentPage++;
        }
        _isFetching = false;
      },
    );
  }
}
