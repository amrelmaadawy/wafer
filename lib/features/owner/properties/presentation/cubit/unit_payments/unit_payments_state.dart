import 'package:equatable/equatable.dart';
import 'package:wafer/features/owner/finance/domain/entities/payment_entity.dart';

abstract class UnitPaymentsState extends Equatable {
  const UnitPaymentsState();

  @override
  List<Object?> get props => [];
}

class UnitPaymentsInitial extends UnitPaymentsState {}

class UnitPaymentsLoading extends UnitPaymentsState {
  final bool isFirstFetch;

  const UnitPaymentsLoading({this.isFirstFetch = true});

  @override
  List<Object?> get props => [isFirstFetch];
}

class UnitPaymentsLoaded extends UnitPaymentsState {
  final List<PaymentEntity> payments;
  final bool hasReachedMax;
  final int currentPage;

  const UnitPaymentsLoaded({
    required this.payments,
    required this.hasReachedMax,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [payments, hasReachedMax, currentPage];
}

class UnitPaymentsEmpty extends UnitPaymentsState {}

class UnitPaymentsError extends UnitPaymentsState {
  final String message;
  final List<PaymentEntity> oldPayments;

  const UnitPaymentsError(this.message, {this.oldPayments = const []});

  @override
  List<Object?> get props => [message, oldPayments];
}
