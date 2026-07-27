import 'package:equatable/equatable.dart';

class EmployeeTasksItemEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int completedTasks;
  final int pendingTasks;
  final int overdueTasks;

  const EmployeeTasksItemEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.completedTasks,
    required this.pendingTasks,
    required this.overdueTasks,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        completedTasks,
        pendingTasks,
        overdueTasks,
      ];
}
