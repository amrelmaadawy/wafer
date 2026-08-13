import 'package:equatable/equatable.dart';

class MaintenanceBreakdownEntity extends Equatable {
  final int newRequests;
  final int inProgress;
  final int urgent;

  const MaintenanceBreakdownEntity({
    required this.newRequests,
    required this.inProgress,
    required this.urgent,
  });

  @override
  List<Object?> get props => [newRequests, inProgress, urgent];
}

class TasksBreakdownEntity extends Equatable {
  final int active;
  final int overdue;

  const TasksBreakdownEntity({required this.active, required this.overdue});

  @override
  List<Object?> get props => [active, overdue];
}

class LegalCasesBreakdownEntity extends Equatable {
  final int openCases;
  final num totalAmount;

  const LegalCasesBreakdownEntity({
    required this.openCases,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [openCases, totalAmount];
}
