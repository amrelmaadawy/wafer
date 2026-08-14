import 'package:equatable/equatable.dart';
import '../../../domain/entities/finance_account_entity.dart';
import '../../../domain/entities/finance_accounts_query_entity.dart';

abstract class FinanceAccountsState extends Equatable {
  const FinanceAccountsState();

  @override
  List<Object?> get props => [];
}

class FinanceAccountsInitial extends FinanceAccountsState {}

class FinanceAccountsLoading extends FinanceAccountsState {}

class FinanceAccountsSuccess extends FinanceAccountsState {
  final List<FinanceAccountEntity> accounts;
  final bool hasReachedMax;
  final int currentPage;
  final FinanceAccountsQueryEntity query;
  final bool isRefetching;

  const FinanceAccountsSuccess({
    required this.accounts,
    required this.hasReachedMax,
    required this.currentPage,
    required this.query,
    this.isRefetching = false,
  });

  FinanceAccountsSuccess copyWith({
    List<FinanceAccountEntity>? accounts,
    bool? hasReachedMax,
    int? currentPage,
    FinanceAccountsQueryEntity? query,
    bool? isRefetching,
  }) {
    return FinanceAccountsSuccess(
      accounts: accounts ?? this.accounts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      query: query ?? this.query,
      isRefetching: isRefetching ?? this.isRefetching,
    );
  }

  @override
  List<Object?> get props => [accounts, hasReachedMax, currentPage, query, isRefetching];
}

class FinanceAccountsError extends FinanceAccountsState {
  final String message;

  const FinanceAccountsError(this.message);

  @override
  List<Object?> get props => [message];
}

class FinanceAccountsEmpty extends FinanceAccountsState {}
