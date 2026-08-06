import 'package:equatable/equatable.dart';

abstract class CreateFinanceAccountState extends Equatable {
  const CreateFinanceAccountState();

  @override
  List<Object> get props => [];
}

class CreateFinanceAccountInitial extends CreateFinanceAccountState {}

class CreateFinanceAccountLoading extends CreateFinanceAccountState {}

class CreateFinanceAccountSuccess extends CreateFinanceAccountState {
  final String message;

  const CreateFinanceAccountSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class CreateFinanceAccountError extends CreateFinanceAccountState {
  final String message;

  const CreateFinanceAccountError(this.message);

  @override
  List<Object> get props => [message];
}
