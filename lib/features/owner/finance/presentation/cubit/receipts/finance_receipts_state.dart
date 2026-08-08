import 'package:equatable/equatable.dart';
import '../../../domain/entities/receipt_entity.dart';

abstract class FinanceReceiptsState extends Equatable {
  const FinanceReceiptsState();

  @override
  List<Object> get props => [];
}

class FinanceReceiptsInitial extends FinanceReceiptsState {}

class FinanceReceiptsLoading extends FinanceReceiptsState {}

class FinanceReceiptsPaginationLoading extends FinanceReceiptsState {
  final List<ReceiptEntity> oldReceipts;
  const FinanceReceiptsPaginationLoading(this.oldReceipts);

  @override
  List<Object> get props => [oldReceipts];
}

class FinanceReceiptsSuccess extends FinanceReceiptsState {
  final List<ReceiptEntity> receipts;
  final bool hasReachedMax;

  const FinanceReceiptsSuccess({
    required this.receipts,
    required this.hasReachedMax,
  });

  @override
  List<Object> get props => [receipts, hasReachedMax];
}

class FinanceReceiptsError extends FinanceReceiptsState {
  final String message;
  final List<ReceiptEntity> oldReceipts;
  const FinanceReceiptsError(this.message, {this.oldReceipts = const []});

  @override
  List<Object> get props => [message, oldReceipts];
}
