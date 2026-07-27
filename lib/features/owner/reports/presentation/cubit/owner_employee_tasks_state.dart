import 'package:equatable/equatable.dart';
import '../../domain/entities/employee_tasks_report_entity.dart';

abstract class OwnerEmployeeTasksState extends Equatable {
  const OwnerEmployeeTasksState();

  @override
  List<Object?> get props => [];
}

class OwnerEmployeeTasksInitial extends OwnerEmployeeTasksState {}

class OwnerEmployeeTasksLoading extends OwnerEmployeeTasksState {
  final bool isPagination;
  const OwnerEmployeeTasksLoading({this.isPagination = false});

  @override
  List<Object?> get props => [isPagination];
}

class OwnerEmployeeTasksLoaded extends OwnerEmployeeTasksState {
  final EmployeeTasksReportEntity report;
  final bool hasReachedMax;

  const OwnerEmployeeTasksLoaded({
    required this.report,
    required this.hasReachedMax,
  });

  @override
  List<Object?> get props => [report, hasReachedMax];
}

class OwnerEmployeeTasksError extends OwnerEmployeeTasksState {
  final String message;

  const OwnerEmployeeTasksError(this.message);

  @override
  List<Object?> get props => [message];
}

class OwnerEmployeeTasksEmpty extends OwnerEmployeeTasksState {}
