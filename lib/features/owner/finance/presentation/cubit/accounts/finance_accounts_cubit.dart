import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_finance_accounts_use_case.dart';
import '../../../domain/entities/finance_accounts_query_entity.dart';
import '../../../domain/entities/finance_account_entity.dart';
import 'finance_accounts_state.dart';

class FinanceAccountsCubit extends Cubit<FinanceAccountsState> {
  final GetFinanceAccountsUseCase getFinanceAccountsUseCase;

  FinanceAccountsCubit(this.getFinanceAccountsUseCase) : super(FinanceAccountsInitial());

  FinanceAccountsQueryEntity _currentQuery = const FinanceAccountsQueryEntity();
  FinanceAccountsQueryEntity get currentQuery => _currentQuery;

  Future<void> fetchAccounts({
    bool isRefresh = false,
    FinanceAccountsQueryEntity? query,
  }) async {
    if (query != null) {
      _currentQuery = query.copyWith(page: 1);
    }

    if (isRefresh || state is! FinanceAccountsSuccess) {
      emit(FinanceAccountsLoading());
    } else {
      final currentState = state as FinanceAccountsSuccess;
      if (currentState.hasReachedMax && query == null && !isRefresh) return;
      emit(currentState.copyWith(isRefetching: true));
    }

    final currentPage = (state is FinanceAccountsSuccess && !isRefresh && query == null)
        ? (state as FinanceAccountsSuccess).currentPage + 1
        : 1;

    _currentQuery = _currentQuery.copyWith(page: currentPage);

    final result = await getFinanceAccountsUseCase(_currentQuery);

    result.fold(
      (failure) {
        // Only emit error if we don't have data, otherwise keep data and stop refetching
        if (state is FinanceAccountsSuccess) {
          final currentState = state as FinanceAccountsSuccess;
          emit(currentState.copyWith(isRefetching: false));
          // Could dispatch a one-off error event if we had an event stream,
          // but emitting Error state drops the data which is bad UX.
          // For now, we just stop loading.
        } else {
          emit(FinanceAccountsError(failure.message));
        }
      },
      (response) {
        if (response.accounts.isEmpty && currentPage == 1) {
          emit(FinanceAccountsEmpty());
          return;
        }

        final hasReachedMax = response.pagination.currentPage >= response.pagination.lastPage;

        if (state is FinanceAccountsSuccess && !isRefresh && query == null) {
          final currentState = state as FinanceAccountsSuccess;
          emit(FinanceAccountsSuccess(
            accounts: _deduplicate(currentState.accounts, response.accounts),
            hasReachedMax: hasReachedMax,
            currentPage: currentPage,
            query: _currentQuery,
            isRefetching: false,
          ));
        } else {
          emit(FinanceAccountsSuccess(
            accounts: response.accounts,
            hasReachedMax: hasReachedMax,
            currentPage: currentPage,
            query: _currentQuery,
            isRefetching: false,
          ));
        }
      },
    );
  }

  List<FinanceAccountEntity> _deduplicate(
      List<FinanceAccountEntity> current, List<FinanceAccountEntity> next) {
    final ids = current.map((e) => e.id).toSet();
    final newItems = next.where((e) => !ids.contains(e.id)).toList();
    return [...current, ...newItems];
  }
}

