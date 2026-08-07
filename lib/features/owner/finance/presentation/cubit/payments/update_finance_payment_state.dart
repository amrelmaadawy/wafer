import 'package:equatable/equatable.dart';
import 'package:wafer/features/owner/finance/domain/entities/payment_entity.dart';

abstract class UpdateFinancePaymentState extends Equatable {
  const UpdateFinancePaymentState();

  @override
  List<Object?> get props => [];
}

class UpdateFinancePaymentInitial extends UpdateFinancePaymentState {}

class UpdateFinancePaymentLoading extends UpdateFinancePaymentState {}

class UpdateFinancePaymentSuccess extends UpdateFinancePaymentState {
  final PaymentEntity payment;
  final String message;

  const UpdateFinancePaymentSuccess({required this.payment, required this.message});

  @override
  List<Object?> get props => [payment, message];
}

class UpdateFinancePaymentError extends UpdateFinancePaymentState {
  final String message;

  const UpdateFinancePaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
