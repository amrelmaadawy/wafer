import 'package:equatable/equatable.dart';
import '../../../domain/entities/finance_account_entity.dart';

abstract class FinanceAccountDetailsState extends Equatable {
  const FinanceAccountDetailsState();

  @override
  List<Object?> get props => [];
}

class FinanceAccountDetailsInitial extends FinanceAccountDetailsState {}

class FinanceAccountDetailsLoading extends FinanceAccountDetailsState {}

class FinanceAccountDetailsSuccess extends FinanceAccountDetailsState {
  final FinanceAccountEntity account;

  const FinanceAccountDetailsSuccess(this.account);

  @override
  List<Object?> get props => [account];
}

class FinanceAccountDetailsError extends FinanceAccountDetailsState {
  final String message;

  const FinanceAccountDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
