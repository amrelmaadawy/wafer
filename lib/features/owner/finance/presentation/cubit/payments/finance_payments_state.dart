import 'package:equatable/equatable.dart';
import '../../../domain/entities/payment_entity.dart';

abstract class FinancePaymentsState extends Equatable {
  const FinancePaymentsState();

  @override
  List<Object> get props => [];
}

class FinancePaymentsInitial extends FinancePaymentsState {}

class FinancePaymentsLoading extends FinancePaymentsState {
  final bool isFirstFetch;

  const FinancePaymentsLoading({this.isFirstFetch = false});

  @override
  List<Object> get props => [isFirstFetch];
}

class FinancePaymentsLoaded extends FinancePaymentsState {
  final List<PaymentEntity> payments;
  final bool hasReachedMax;
  final int currentPage;

  const FinancePaymentsLoaded({
    required this.payments,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  FinancePaymentsLoaded copyWith({
    List<PaymentEntity>? payments,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return FinancePaymentsLoaded(
      payments: payments ?? this.payments,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [payments, hasReachedMax, currentPage];
}

class FinancePaymentsError extends FinancePaymentsState {
  final String message;
  final List<PaymentEntity> oldPayments;
  const FinancePaymentsError(this.message, {this.oldPayments = const []});

  @override
  List<Object> get props => [message, oldPayments];
}

class FinancePaymentsEmpty extends FinancePaymentsState {}
