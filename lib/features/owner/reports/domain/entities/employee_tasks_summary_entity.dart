import 'package:equatable/equatable.dart';

class EmployeeTasksSummaryEntity extends Equatable {
  final int totalEmployees;
  final int totalCompleted;
  final int totalPending;
  final int totalOverdue;

  const EmployeeTasksSummaryEntity({
    required this.totalEmployees,
    required this.totalCompleted,
    required this.totalPending,
    required this.totalOverdue,
  });

  @override
  List<Object?> get props => [
    totalEmployees,
    totalCompleted,
    totalPending,
    totalOverdue,
  ];
}
