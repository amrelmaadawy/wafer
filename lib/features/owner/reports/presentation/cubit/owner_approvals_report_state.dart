import 'package:equatable/equatable.dart';
import '../../domain/entities/approvals_report_entity.dart';

abstract class OwnerApprovalsReportState extends Equatable {
  const OwnerApprovalsReportState();

  @override
  List<Object?> get props => [];
}

class OwnerApprovalsReportInitial extends OwnerApprovalsReportState {}

class OwnerApprovalsReportLoading extends OwnerApprovalsReportState {
  final bool isFirstFetch;
  final ApprovalsReportEntity? report;

  const OwnerApprovalsReportLoading({this.isFirstFetch = false, this.report});

  @override
  List<Object?> get props => [isFirstFetch, report];
}

class OwnerApprovalsReportLoaded extends OwnerApprovalsReportState {
  final ApprovalsReportEntity report;
  final bool hasReachedMax;

  const OwnerApprovalsReportLoaded({
    required this.report,
    required this.hasReachedMax,
  });

  @override
  List<Object?> get props => [report, hasReachedMax];
}

class OwnerApprovalsReportEmpty extends OwnerApprovalsReportState {}

class OwnerApprovalsReportError extends OwnerApprovalsReportState {
  final String message;

  const OwnerApprovalsReportError({required this.message});

  @override
  List<Object?> get props => [message];
}
