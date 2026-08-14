import '../../domain/entities/employee_tasks_item_entity.dart';
import 'report_model_parsing.dart';

class EmployeeTasksItemModel extends EmployeeTasksItemEntity {
  const EmployeeTasksItemModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.completedTasks,
    required super.pendingTasks,
    required super.overdueTasks,
  });

  factory EmployeeTasksItemModel.fromJson(Map<String, dynamic> json) {
    return EmployeeTasksItemModel(
      id: reportInt(json['id']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      completedTasks: reportInt(json['completed_tasks']),
      pendingTasks: reportInt(json['pending_tasks']),
      overdueTasks: reportInt(json['overdue_tasks']),
    );
  }
}
