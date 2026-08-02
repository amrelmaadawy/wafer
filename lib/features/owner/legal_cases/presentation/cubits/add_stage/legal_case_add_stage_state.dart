import 'package:equatable/equatable.dart';
import 'package:wafer/features/owner/legal_cases/domain/entities/legal_case_item_entity.dart';


abstract class LegalCaseAddStageState extends Equatable {
  const LegalCaseAddStageState();

  @override
  List<Object> get props => [];
}

class LegalCaseAddStageInitial extends LegalCaseAddStageState {}

class LegalCaseAddStageLoading extends LegalCaseAddStageState {}

class LegalCaseAddStageSuccess extends LegalCaseAddStageState {
  final LegalCaseItemEntity legalCase;

  const LegalCaseAddStageSuccess(this.legalCase);

  @override
  List<Object> get props => [legalCase];
}

class LegalCaseAddStageError extends LegalCaseAddStageState {
  final String message;

  const LegalCaseAddStageError(this.message);

  @override
  List<Object> get props => [message];
}
