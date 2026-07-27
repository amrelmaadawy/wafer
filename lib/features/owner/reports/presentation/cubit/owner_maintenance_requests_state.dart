import 'package:equatable/equatable.dart';
import '../../domain/entities/maintenance_requests_report_entity.dart';

abstract class OwnerMaintenanceRequestsState extends Equatable {
  const OwnerMaintenanceRequestsState();

  @override
  List<Object?> get props => [];
}

class OwnerMaintenanceRequestsInitial extends OwnerMaintenanceRequestsState {}

class OwnerMaintenanceRequestsLoading extends OwnerMaintenanceRequestsState {
  final bool isPagination;
  const OwnerMaintenanceRequestsLoading({this.isPagination = false});

  @override
  List<Object?> get props => [isPagination];
}

class OwnerMaintenanceRequestsLoaded extends OwnerMaintenanceRequestsState {
  final MaintenanceRequestsReportEntity report;
  final bool hasReachedMax;

  const OwnerMaintenanceRequestsLoaded(this.report, {this.hasReachedMax = false});

  @override
  List<Object?> get props => [report, hasReachedMax];
}

class OwnerMaintenanceRequestsEmpty extends OwnerMaintenanceRequestsState {}

class OwnerMaintenanceRequestsError extends OwnerMaintenanceRequestsState {
  final String message;
  const OwnerMaintenanceRequestsError(this.message);

  @override
  List<Object?> get props => [message];
}
