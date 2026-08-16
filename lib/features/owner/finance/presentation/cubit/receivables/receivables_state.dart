import 'package:equatable/equatable.dart';
import '../../../domain/entities/receivable_entity.dart';

abstract class ReceivablesState extends Equatable {
  const ReceivablesState();

  @override
  List<Object?> get props => [];
}

class ReceivablesInitial extends ReceivablesState {}

class ReceivablesLoading extends ReceivablesState {}

class ReceivablesLoaded extends ReceivablesState {
  final List<ReceivableEntity> receivables;
  final List<ReceivableEntity> allReceivables;
  final String activeStatus;
  final num totalAmount;
  final num totalPaid;
  final num totalRemaining;
  final double collectionRate;
  final int overdueCount;
  final bool hasMore;

  const ReceivablesLoaded({
    required this.receivables,
    required this.allReceivables,
    this.activeStatus = 'all',
    required this.totalAmount,
    required this.totalPaid,
    required this.totalRemaining,
    required this.collectionRate,
    required this.overdueCount,
    this.hasMore = false,
  });

  @override
  List<Object?> get props => [
        receivables,
        allReceivables,
        activeStatus,
        totalAmount,
        totalPaid,
        totalRemaining,
        collectionRate,
        overdueCount,
        hasMore,
      ];
}

class ReceivablesEmpty extends ReceivablesState {
  final String activeStatus;
  const ReceivablesEmpty({this.activeStatus = 'all'});

  @override
  List<Object?> get props => [activeStatus];
}

class ReceivablesError extends ReceivablesState {
  final String message;

  const ReceivablesError({required this.message});

  @override
  List<Object?> get props => [message];
}
