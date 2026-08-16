import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/unified_transaction_entity.dart';
import '../../../domain/entities/unified_transactions_query_entity.dart';
import '../../../domain/usecases/get_unified_transactions_use_case.dart';
import 'unified_transactions_state.dart';

class UnifiedTransactionsCubit extends Cubit<UnifiedTransactionsState> {
  final GetUnifiedTransactionsUseCase getUnifiedTransactionsUseCase;

  UnifiedTransactionsCubit({required this.getUnifiedTransactionsUseCase})
      : super(UnifiedTransactionsInitial());

  UnifiedTransactionsQueryEntity _query = const UnifiedTransactionsQueryEntity();
  bool _isLoadingMore = false;

  Future<void> loadTransactions({UnifiedTransactionsQueryEntity? query}) async {
    _query = query ?? const UnifiedTransactionsQueryEntity();
    emit(UnifiedTransactionsLoading());

    final result = await getUnifiedTransactionsUseCase(_query);

    result.fold(
      (failure) => emit(UnifiedTransactionsError(message: failure.message)),
      (transactions) {
        if (transactions.isEmpty) {
          emit(UnifiedTransactionsEmpty(currentQuery: _query));
        } else {
          _emitLoaded(transactions, transactions.length >= _query.limit, _query);
        }
      },
    );
  }

  Future<void> loadMoreTransactions() async {
    final currentState = state;
    if (currentState is! UnifiedTransactionsLoaded || _isLoadingMore || !currentState.hasMore) {
      return;
    }

    _isLoadingMore = true;
    final nextPage = currentState.currentQuery.page + 1;
    final nextQuery = currentState.currentQuery.copyWith(page: nextPage);

    final result = await getUnifiedTransactionsUseCase(nextQuery);

    result.fold(
      (_) => _isLoadingMore = false,
      (newTransactions) {
        _isLoadingMore = false;
        final updatedList = [...currentState.transactions, ...newTransactions];
        _emitLoaded(updatedList, newTransactions.length >= nextQuery.limit, nextQuery);
      },
    );
  }

  void filterByType(String? type) {
    final newQuery = _query.copyWith(type: type == 'all' ? null : type, page: 1);
    loadTransactions(query: newQuery);
  }

  void filterByProperty(int? propertyId) {
    final newQuery = _query.copyWith(propertyId: propertyId, page: 1);
    loadTransactions(query: newQuery);
  }

  void applyAdvancedFilter(UnifiedTransactionsQueryEntity updatedQuery) {
    loadTransactions(query: updatedQuery.copyWith(page: 1));
  }

  void resetFilters() {
    loadTransactions(query: const UnifiedTransactionsQueryEntity());
  }

  void _emitLoaded(
    List<UnifiedTransactionEntity> list,
    bool hasMore,
    UnifiedTransactionsQueryEntity query,
  ) {
    final grouped = <String, List<UnifiedTransactionEntity>>{};
    num income = 0;
    num expense = 0;

    for (final tx in list) {
      final dateKey = tx.date.isNotEmpty ? tx.date.split('T').first : 'Unknown';
      grouped.putIfAbsent(dateKey, () => []).add(tx);

      if (tx.isPositive) {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }

    emit(UnifiedTransactionsLoaded(
      transactions: list,
      groupedTransactions: grouped,
      totalIncome: income,
      totalExpense: expense,
      netFlow: income - expense,
      hasMore: hasMore,
      currentQuery: query,
    ));
  }
}
