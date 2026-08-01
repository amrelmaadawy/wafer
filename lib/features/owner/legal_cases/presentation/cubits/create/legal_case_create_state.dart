import 'package:equatable/equatable.dart';
import '../../../domain/entities/legal_case_item_entity.dart';

abstract class LegalCaseCreateState extends Equatable {
  const LegalCaseCreateState();

  @override
  List<Object?> get props => [];
}

class LegalCaseCreateInitial extends LegalCaseCreateState {}

class LegalCaseCreateLoading extends LegalCaseCreateState {}

class LegalCaseCreateSuccess extends LegalCaseCreateState {
  final LegalCaseItemEntity legalCase;

  const LegalCaseCreateSuccess(this.legalCase);

  @override
  List<Object?> get props => [legalCase];
}

class LegalCaseCreateError extends LegalCaseCreateState {
  final String message;

  const LegalCaseCreateError(this.message);

  @override
  List<Object?> get props => [message];
}
