import 'package:equatable/equatable.dart';
import 'package:wafer/features/owner/finance/domain/entities/payment_entity.dart';

abstract class PropertyFinanceState extends Equatable {
  const PropertyFinanceState();

  @override
  List<Object?> get props => [];
}

class PropertyFinanceInitial extends PropertyFinanceState {}

class PropertyFinanceLoading extends PropertyFinanceState {
  final bool isFirstFetch;

  const PropertyFinanceLoading({this.isFirstFetch = true});

  @override
  List<Object?> get props => [isFirstFetch];
}

class PropertyFinanceLoaded extends PropertyFinanceState {
  final List<PaymentEntity> payments;
  final bool hasReachedMax;
  final int currentPage;

  const PropertyFinanceLoaded({
    required this.payments,
    required this.hasReachedMax,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [payments, hasReachedMax, currentPage];
}

class PropertyFinanceEmpty extends PropertyFinanceState {}

class PropertyFinanceError extends PropertyFinanceState {
  final String message;
  final List<PaymentEntity> oldPayments;

  const PropertyFinanceError(this.message, {this.oldPayments = const []});

  @override
  List<Object?> get props => [message, oldPayments];
}
