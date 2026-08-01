import 'package:equatable/equatable.dart';
import '../../../domain/entities/legal_case_form_data_entity.dart';

abstract class LegalCaseFormDataState extends Equatable {
  const LegalCaseFormDataState();

  @override
  List<Object> get props => [];
}

class LegalCaseFormDataInitial extends LegalCaseFormDataState {}

class LegalCaseFormDataLoading extends LegalCaseFormDataState {}

class LegalCaseFormDataLoaded extends LegalCaseFormDataState {
  final LegalCaseFormDataEntity formData;

  const LegalCaseFormDataLoaded({required this.formData});

  @override
  List<Object> get props => [formData];
}

class LegalCaseFormDataError extends LegalCaseFormDataState {
  final String message;

  const LegalCaseFormDataError({required this.message});

  @override
  List<Object> get props => [message];
}
