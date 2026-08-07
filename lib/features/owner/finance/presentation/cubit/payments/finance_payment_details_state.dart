import 'package:equatable/equatable.dart';
import '../../../domain/entities/payment_entity.dart';

abstract class FinancePaymentDetailsState extends Equatable {
  const FinancePaymentDetailsState();

  @override
  List<Object?> get props => [];
}

class FinancePaymentDetailsInitial extends FinancePaymentDetailsState {}

class FinancePaymentDetailsLoading extends FinancePaymentDetailsState {}

class FinancePaymentDetailsSuccess extends FinancePaymentDetailsState {
  final PaymentEntity payment;

  const FinancePaymentDetailsSuccess({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class FinancePaymentDetailsError extends FinancePaymentDetailsState {
  final String message;

  const FinancePaymentDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
