import 'package:equatable/equatable.dart';
import 'package:wafer/features/owner/finance/domain/entities/payment_entity.dart';

abstract class ContractPaymentsState extends Equatable {
  const ContractPaymentsState();

  @override
  List<Object?> get props => [];
}

class ContractPaymentsInitial extends ContractPaymentsState {}

class ContractPaymentsLoading extends ContractPaymentsState {
  final bool isFirstFetch;

  const ContractPaymentsLoading({this.isFirstFetch = true});

  @override
  List<Object?> get props => [isFirstFetch];
}

class ContractPaymentsLoaded extends ContractPaymentsState {
  final List<PaymentEntity> payments;
  final bool hasReachedMax;
  final int currentPage;

  const ContractPaymentsLoaded({
    required this.payments,
    required this.hasReachedMax,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [payments, hasReachedMax, currentPage];
}

class ContractPaymentsEmpty extends ContractPaymentsState {}

class ContractPaymentsError extends ContractPaymentsState {
  final String message;
  final List<PaymentEntity> oldPayments;

  const ContractPaymentsError(this.message, {this.oldPayments = const []});

  @override
  List<Object?> get props => [message, oldPayments];
}
