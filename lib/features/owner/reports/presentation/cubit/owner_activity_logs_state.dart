import 'package:equatable/equatable.dart';
import '../../domain/entities/activity_logs_report_entity.dart';

abstract class OwnerActivityLogsState extends Equatable {
  const OwnerActivityLogsState();

  @override
  List<Object?> get props => [];
}

class OwnerActivityLogsInitial extends OwnerActivityLogsState {}

class OwnerActivityLogsLoading extends OwnerActivityLogsState {
  final bool isPagination;
  const OwnerActivityLogsLoading({this.isPagination = false});

  @override
  List<Object?> get props => [isPagination];
}

class OwnerActivityLogsLoaded extends OwnerActivityLogsState {
  final ActivityLogsReportEntity report;

  const OwnerActivityLogsLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class OwnerActivityLogsError extends OwnerActivityLogsState {
  final String message;

  const OwnerActivityLogsError(this.message);

  @override
  List<Object?> get props => [message];
}

class OwnerActivityLogsEmpty extends OwnerActivityLogsState {}
