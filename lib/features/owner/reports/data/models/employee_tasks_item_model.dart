import '../../domain/entities/employee_tasks_item_entity.dart';

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
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      completedTasks: json['completed_tasks'] ?? 0,
      pendingTasks: json['pending_tasks'] ?? 0,
      overdueTasks: json['overdue_tasks'] ?? 0,
    );
  }
}
