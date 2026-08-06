import 'package:equatable/equatable.dart';
import '../../../domain/entities/receipt_entity.dart';

abstract class FinanceReceiptDetailsState extends Equatable {
  const FinanceReceiptDetailsState();

  @override
  List<Object> get props => [];
}

class FinanceReceiptDetailsInitial extends FinanceReceiptDetailsState {}

class FinanceReceiptDetailsLoading extends FinanceReceiptDetailsState {}

class FinanceReceiptDetailsSuccess extends FinanceReceiptDetailsState {
  final ReceiptEntity receipt;

  const FinanceReceiptDetailsSuccess(this.receipt);

  @override
  List<Object> get props => [receipt];
}

class FinanceReceiptDetailsError extends FinanceReceiptDetailsState {
  final String message;

  const FinanceReceiptDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
