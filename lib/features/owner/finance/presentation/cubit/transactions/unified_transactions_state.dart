import 'package:equatable/equatable.dart';
import '../../../domain/entities/unified_transaction_entity.dart';
import '../../../domain/entities/unified_transactions_query_entity.dart';

abstract class UnifiedTransactionsState extends Equatable {
  const UnifiedTransactionsState();

  @override
  List<Object?> get props => [];
}

class UnifiedTransactionsInitial extends UnifiedTransactionsState {}

class UnifiedTransactionsLoading extends UnifiedTransactionsState {}

class UnifiedTransactionsLoaded extends UnifiedTransactionsState {
  final List<UnifiedTransactionEntity> transactions;
  final Map<String, List<UnifiedTransactionEntity>> groupedTransactions;
  final num totalIncome;
  final num totalExpense;
  final num netFlow;
  final bool hasMore;
  final UnifiedTransactionsQueryEntity currentQuery;

  const UnifiedTransactionsLoaded({
    required this.transactions,
    required this.groupedTransactions,
    required this.totalIncome,
    required this.totalExpense,
    required this.netFlow,
    required this.hasMore,
    required this.currentQuery,
  });

  @override
  List<Object?> get props => [
        transactions,
        groupedTransactions,
        totalIncome,
        totalExpense,
        netFlow,
        hasMore,
        currentQuery,
      ];
}

class UnifiedTransactionsEmpty extends UnifiedTransactionsState {
  final UnifiedTransactionsQueryEntity currentQuery;

  const UnifiedTransactionsEmpty({required this.currentQuery});

  @override
  List<Object?> get props => [currentQuery];
}

class UnifiedTransactionsError extends UnifiedTransactionsState {
  final String message;

  const UnifiedTransactionsError({required this.message});

  @override
  List<Object?> get props => [message];
}
