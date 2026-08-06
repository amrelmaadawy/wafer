import 'package:equatable/equatable.dart';

abstract class CreateFinanceReceiptState extends Equatable {
  const CreateFinanceReceiptState();

  @override
  List<Object?> get props => [];
}

class CreateFinanceReceiptInitial extends CreateFinanceReceiptState {}

class CreateFinanceReceiptLoading extends CreateFinanceReceiptState {}

class CreateFinanceReceiptSuccess extends CreateFinanceReceiptState {
  final String message;

  const CreateFinanceReceiptSuccess({this.message = 'Receipt created successfully'});

  @override
  List<Object?> get props => [message];
}

class CreateFinanceReceiptError extends CreateFinanceReceiptState {
  final String message;

  const CreateFinanceReceiptError(this.message);

  @override
  List<Object?> get props => [message];
}
