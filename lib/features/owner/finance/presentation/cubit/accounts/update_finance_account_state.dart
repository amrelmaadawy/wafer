import 'package:equatable/equatable.dart';

abstract class UpdateFinanceAccountState extends Equatable {
  const UpdateFinanceAccountState();

  @override
  List<Object> get props => [];
}

class UpdateFinanceAccountInitial extends UpdateFinanceAccountState {}

class UpdateFinanceAccountLoading extends UpdateFinanceAccountState {}

class UpdateFinanceAccountSuccess extends UpdateFinanceAccountState {
  final String message;

  const UpdateFinanceAccountSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class UpdateFinanceAccountError extends UpdateFinanceAccountState {
  final String message;

  const UpdateFinanceAccountError(this.message);

  @override
  List<Object> get props => [message];
}
