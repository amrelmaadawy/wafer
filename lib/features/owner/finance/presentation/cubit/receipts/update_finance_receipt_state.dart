import 'package:equatable/equatable.dart';
import '../../../domain/entities/receipt_entity.dart';

abstract class UpdateFinanceReceiptState extends Equatable {
  const UpdateFinanceReceiptState();

  @override
  List<Object> get props => [];
}

class UpdateFinanceReceiptInitial extends UpdateFinanceReceiptState {}

class UpdateFinanceReceiptLoading extends UpdateFinanceReceiptState {}

class UpdateFinanceReceiptSuccess extends UpdateFinanceReceiptState {
  final ReceiptEntity receipt;
  final String message;

  const UpdateFinanceReceiptSuccess({required this.receipt, required this.message});

  @override
  List<Object> get props => [receipt, message];
}

class UpdateFinanceReceiptError extends UpdateFinanceReceiptState {
  final String message;

  const UpdateFinanceReceiptError(this.message);

  @override
  List<Object> get props => [message];
}
