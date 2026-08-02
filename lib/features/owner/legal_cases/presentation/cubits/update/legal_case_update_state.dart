import 'package:equatable/equatable.dart';
import '../../../domain/entities/legal_case_item_entity.dart';

abstract class LegalCaseUpdateState extends Equatable {
  const LegalCaseUpdateState();

  @override
  List<Object?> get props => [];
}

class LegalCaseUpdateInitial extends LegalCaseUpdateState {}

class LegalCaseUpdateLoading extends LegalCaseUpdateState {}

class LegalCaseUpdateSuccess extends LegalCaseUpdateState {
  final LegalCaseItemEntity legalCase;

  const LegalCaseUpdateSuccess(this.legalCase);

  @override
  List<Object?> get props => [legalCase];
}

class LegalCaseUpdateError extends LegalCaseUpdateState {
  final String message;
  final Map<String, List<dynamic>>? errors;

  const LegalCaseUpdateError(this.message, {this.errors});

  @override
  List<Object?> get props => [message, errors];
}
