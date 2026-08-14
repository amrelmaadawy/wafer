import '../../domain/entities/employee_tasks_summary_entity.dart';
import 'report_model_parsing.dart';

class EmployeeTasksSummaryModel extends EmployeeTasksSummaryEntity {
  const EmployeeTasksSummaryModel({
    required super.totalEmployees,
    required super.totalCompleted,
    required super.totalPending,
    required super.totalOverdue,
  });

  factory EmployeeTasksSummaryModel.fromJson(Map<String, dynamic> json) {
    return EmployeeTasksSummaryModel(
      totalEmployees: reportInt(json['total_employees']),
      totalCompleted: reportInt(json['total_completed']),
      totalPending: reportInt(json['total_pending']),
      totalOverdue: reportInt(json['total_overdue']),
    );
  }
}
