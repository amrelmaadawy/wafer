import 'package:equatable/equatable.dart';
import '../../../domain/entities/receipt_entity.dart';

abstract class CancelFinanceReceiptState extends Equatable {
  const CancelFinanceReceiptState();

  @override
  List<Object?> get props => [];
}

class CancelFinanceReceiptInitial extends CancelFinanceReceiptState {}

class CancelFinanceReceiptLoading extends CancelFinanceReceiptState {}

class CancelFinanceReceiptSuccess extends CancelFinanceReceiptState {
  final ReceiptEntity receipt;

  const CancelFinanceReceiptSuccess(this.receipt);

  @override
  List<Object?> get props => [receipt];
}

class CancelFinanceReceiptError extends CancelFinanceReceiptState {
  final String message;

  const CancelFinanceReceiptError(this.message);

  @override
  List<Object?> get props => [message];
}
