import 'package:equatable/equatable.dart';

abstract class LegalCaseDeleteState extends Equatable {
  const LegalCaseDeleteState();

  @override
  List<Object> get props => [];
}

class LegalCaseDeleteInitial extends LegalCaseDeleteState {}

class LegalCaseDeleteLoading extends LegalCaseDeleteState {}

class LegalCaseDeleteSuccess extends LegalCaseDeleteState {}

class LegalCaseDeleteError extends LegalCaseDeleteState {
  final String message;

  const LegalCaseDeleteError(this.message);

  @override
  List<Object> get props => [message];
}
