import 'package:equatable/equatable.dart';
import '../../../domain/entities/payable_entity.dart';

abstract class PayablesState extends Equatable {
  const PayablesState();

  @override
  List<Object?> get props => [];
}

class PayablesInitial extends PayablesState {}

class PayablesLoading extends PayablesState {}

class PayablesLoaded extends PayablesState {
  final List<PayableEntity> payables;
  final List<PayableEntity> allPayables;
  final String activeStatus;
  final num totalAmount;
  final num totalPaid;
  final num totalRemaining;
  final double paymentRate;
  final int overdueCount;
  final bool hasMore;

  const PayablesLoaded({
    required this.payables,
    required this.allPayables,
    this.activeStatus = 'all',
    required this.totalAmount,
    required this.totalPaid,
    required this.totalRemaining,
    required this.paymentRate,
    required this.overdueCount,
    this.hasMore = false,
  });

  @override
  List<Object?> get props => [
        payables,
        allPayables,
        activeStatus,
        totalAmount,
        totalPaid,
        totalRemaining,
        paymentRate,
        overdueCount,
        hasMore,
      ];
}

class PayablesEmpty extends PayablesState {
  final String activeStatus;
  const PayablesEmpty({this.activeStatus = 'all'});

  @override
  List<Object?> get props => [activeStatus];
}

class PayablesError extends PayablesState {
  final String message;

  const PayablesError({required this.message});

  @override
  List<Object?> get props => [message];
}
