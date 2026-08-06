import 'package:equatable/equatable.dart';
import '../../../domain/entities/finance_account_entity.dart';

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

  const FinanceAccountsSuccess({
    required this.accounts,
    required this.hasReachedMax,
    required this.currentPage,
  });

  FinanceAccountsSuccess copyWith({
    List<FinanceAccountEntity>? accounts,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return FinanceAccountsSuccess(
      accounts: accounts ?? this.accounts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [accounts, hasReachedMax, currentPage];
}

class FinanceAccountsError extends FinanceAccountsState {
  final String message;

  const FinanceAccountsError(this.message);

  @override
  List<Object?> get props => [message];
}

class FinanceAccountsEmpty extends FinanceAccountsState {}
