import 'package:equatable/equatable.dart';

abstract class LegalCaseDeleteStageState extends Equatable {
  const LegalCaseDeleteStageState();

  @override
  List<Object> get props => [];
}

class LegalCaseDeleteStageInitial extends LegalCaseDeleteStageState {}

class LegalCaseDeleteStageLoading extends LegalCaseDeleteStageState {}

class LegalCaseDeleteStageSuccess extends LegalCaseDeleteStageState {}

class LegalCaseDeleteStageError extends LegalCaseDeleteStageState {
  final String message;

  const LegalCaseDeleteStageError(this.message);

  @override
  List<Object> get props => [message];
}
