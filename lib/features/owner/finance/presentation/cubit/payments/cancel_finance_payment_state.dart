import 'package:equatable/equatable.dart';

abstract class CancelFinancePaymentState extends Equatable {
  const CancelFinancePaymentState();

  @override
  List<Object?> get props => [];
}

class CancelFinancePaymentInitial extends CancelFinancePaymentState {}

class CancelFinancePaymentLoading extends CancelFinancePaymentState {}

class CancelFinancePaymentSuccess extends CancelFinancePaymentState {}

class CancelFinancePaymentError extends CancelFinancePaymentState {
  final String message;

  const CancelFinancePaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}
