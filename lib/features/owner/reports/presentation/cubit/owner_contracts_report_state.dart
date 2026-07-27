import 'package:equatable/equatable.dart';
import '../../domain/entities/contracts_report_entity.dart';

abstract class OwnerContractsReportState extends Equatable {
  const OwnerContractsReportState();

  @override
  List<Object> get props => [];
}

class OwnerContractsReportInitial extends OwnerContractsReportState {}

class OwnerContractsReportLoading extends OwnerContractsReportState {}

class OwnerContractsReportLoaded extends OwnerContractsReportState {
  final ContractsReportEntity report;
  final bool hasReachedMax;

  const OwnerContractsReportLoaded({
    required this.report,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [report, hasReachedMax];
}

class OwnerContractsReportError extends OwnerContractsReportState {
  final String message;

  const OwnerContractsReportError(this.message);

  @override
  List<Object> get props => [message];
}

class OwnerContractsReportEmpty extends OwnerContractsReportState {}
