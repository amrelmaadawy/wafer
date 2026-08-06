import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_finance_accounts_use_case.dart';
import 'finance_accounts_state.dart';

class FinanceAccountsCubit extends Cubit<FinanceAccountsState> {
  final GetFinanceAccountsUseCase getFinanceAccountsUseCase;

  FinanceAccountsCubit(this.getFinanceAccountsUseCase) : super(FinanceAccountsInitial());

  String _currentSearchQuery = '';

  Future<void> fetchAccounts({bool isRefresh = false, String? search}) async {
    if (search != null) {
      _currentSearchQuery = search;
    }

    if (isRefresh || state is! FinanceAccountsSuccess) {
      emit(FinanceAccountsLoading());
    } else {
      final currentState = state as FinanceAccountsSuccess;
      if (currentState.hasReachedMax) return;
    }

    final currentPage = (state is FinanceAccountsSuccess && !isRefresh)
        ? (state as FinanceAccountsSuccess).currentPage + 1
        : 1;

    final result = await getFinanceAccountsUseCase(
      page: currentPage,
      perPage: 15,
      search: _currentSearchQuery,
    );

    result.fold(
      (failure) {
        if (state is FinanceAccountsSuccess) {
          emit(FinanceAccountsError(failure.message)); // Or handle differently if paginating
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

        if (state is FinanceAccountsSuccess && !isRefresh) {
          final currentState = state as FinanceAccountsSuccess;
          emit(FinanceAccountsSuccess(
            accounts: currentState.accounts + response.accounts,
            hasReachedMax: hasReachedMax,
            currentPage: currentPage,
          ));
        } else {
          emit(FinanceAccountsSuccess(
            accounts: response.accounts,
            hasReachedMax: hasReachedMax,
            currentPage: currentPage,
          ));
        }
      },
    );
  }
}
