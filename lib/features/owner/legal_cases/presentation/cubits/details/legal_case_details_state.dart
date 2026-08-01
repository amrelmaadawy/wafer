import 'package:equatable/equatable.dart';
import '../../../domain/entities/legal_case_item_entity.dart';

abstract class LegalCaseDetailsState extends Equatable {
  const LegalCaseDetailsState();

  @override
  List<Object?> get props => [];
}

class LegalCaseDetailsInitial extends LegalCaseDetailsState {}

class LegalCaseDetailsLoading extends LegalCaseDetailsState {}

class LegalCaseDetailsLoaded extends LegalCaseDetailsState {
  final LegalCaseItemEntity legalCase;

  const LegalCaseDetailsLoaded({required this.legalCase});

  @override
  List<Object?> get props => [legalCase];
}

class LegalCaseDetailsError extends LegalCaseDetailsState {
  final String message;

  const LegalCaseDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
