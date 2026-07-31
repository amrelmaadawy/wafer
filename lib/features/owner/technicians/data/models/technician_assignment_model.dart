import '../../domain/entities/technician_assignment_entity.dart';

class TechnicianAssignmentModel extends TechnicianAssignmentEntity {
  const TechnicianAssignmentModel({
    required super.id,
    super.maintenanceRequestId,
    super.requestNumber,
    super.property,
    super.unit,
    super.taskDetails,
    super.status,
    super.statusLabel,
    super.dueDate,
    super.assignedAt,
    super.completedAt,
  });

  factory TechnicianAssignmentModel.fromJson(Map<String, dynamic> json) {
    return TechnicianAssignmentModel(
      id: json['id'] as int,
      maintenanceRequestId: json['maintenance_request_id'] as int?,
      requestNumber: json['request_number'] as String?,
      property: json['property'] as Map<String, dynamic>?,
      unit: json['unit'] as Map<String, dynamic>?,
      taskDetails: json['task_details'] as String?,
      status: json['status'] as String?,
      statusLabel: json['status_label'] as String?,
      dueDate: json['due_date'] as String?,
      assignedAt: json['assigned_at'] as String?,
      completedAt: json['completed_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maintenance_request_id': maintenanceRequestId,
      'request_number': requestNumber,
      'property': property,
      'unit': unit,
      'task_details': taskDetails,
      'status': status,
      'status_label': statusLabel,
      'due_date': dueDate,
      'assigned_at': assignedAt,
      'completed_at': completedAt,
    };
  }
}
