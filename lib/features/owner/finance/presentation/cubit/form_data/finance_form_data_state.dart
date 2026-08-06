import 'package:equatable/equatable.dart';
import '../../../domain/entities/finance_form_data_entity.dart';

abstract class FinanceFormDataState extends Equatable {
  const FinanceFormDataState();

  @override
  List<Object?> get props => [];
}

class FinanceFormDataInitial extends FinanceFormDataState {}

class FinanceFormDataLoading extends FinanceFormDataState {}

class FinanceFormDataSuccess extends FinanceFormDataState {
  final FinanceFormDataEntity formData;

  const FinanceFormDataSuccess(this.formData);

  @override
  List<Object?> get props => [formData];
}

class FinanceFormDataError extends FinanceFormDataState {
  final String message;

  const FinanceFormDataError(this.message);

  @override
  List<Object?> get props => [message];
}
