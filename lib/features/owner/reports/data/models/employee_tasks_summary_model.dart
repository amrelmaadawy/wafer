import '../../domain/entities/employee_tasks_summary_entity.dart';

class EmployeeTasksSummaryModel extends EmployeeTasksSummaryEntity {
  const EmployeeTasksSummaryModel({
    required super.totalEmployees,
    required super.totalCompleted,
    required super.totalPending,
    required super.totalOverdue,
  });

  factory EmployeeTasksSummaryModel.fromJson(Map<String, dynamic> json) {
    return EmployeeTasksSummaryModel(
      totalEmployees: json['total_employees'] ?? 0,
      totalCompleted: json['total_completed'] ?? 0,
      totalPending: json['total_pending'] ?? 0,
      totalOverdue: json['total_overdue'] ?? 0,
    );
  }
}
