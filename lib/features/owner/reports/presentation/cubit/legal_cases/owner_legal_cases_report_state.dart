import 'package:equatable/equatable.dart';
import '../../../domain/entities/legal_cases_report_entity.dart';

abstract class OwnerLegalCasesReportState extends Equatable {
  const OwnerLegalCasesReportState();

  @override
  List<Object> get props => [];
}

class OwnerLegalCasesReportInitial extends OwnerLegalCasesReportState {}

class OwnerLegalCasesReportLoading extends OwnerLegalCasesReportState {
  final bool isFirstFetch;

  const OwnerLegalCasesReportLoading({this.isFirstFetch = false});

  @override
  List<Object> get props => [isFirstFetch];
}

class OwnerLegalCasesReportLoaded extends OwnerLegalCasesReportState {
  final LegalCasesReportEntity report;

  const OwnerLegalCasesReportLoaded(this.report);

  @override
  List<Object> get props => [report];
}

class OwnerLegalCasesReportEmpty extends OwnerLegalCasesReportState {}

class OwnerLegalCasesReportError extends OwnerLegalCasesReportState {
  final String message;

  const OwnerLegalCasesReportError(this.message);

  @override
  List<Object> get props => [message];
}
