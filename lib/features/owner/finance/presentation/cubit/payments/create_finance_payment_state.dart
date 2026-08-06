import 'package:equatable/equatable.dart';

abstract class CreateFinancePaymentState extends Equatable {
  const CreateFinancePaymentState();

  @override
  List<Object?> get props => [];
}

class CreateFinancePaymentInitial extends CreateFinancePaymentState {}

class CreateFinancePaymentLoading extends CreateFinancePaymentState {}

class CreateFinancePaymentSuccess extends CreateFinancePaymentState {
  final String message;

  const CreateFinancePaymentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateFinancePaymentError extends CreateFinancePaymentState {
  final String message;

  const CreateFinancePaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
