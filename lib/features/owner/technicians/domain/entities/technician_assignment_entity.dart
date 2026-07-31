import 'package:equatable/equatable.dart';

class TechnicianAssignmentEntity extends Equatable {
  final int id;
  final int? maintenanceRequestId;
  final String? requestNumber;
  final Map<String, dynamic>? property;
  final Map<String, dynamic>? unit;
  final String? taskDetails;
  final String? status;
  final String? statusLabel;
  final String? dueDate;
  final String? assignedAt;
  final String? completedAt;

  const TechnicianAssignmentEntity({
    required this.id,
    this.maintenanceRequestId,
    this.requestNumber,
    this.property,
    this.unit,
    this.taskDetails,
    this.status,
    this.statusLabel,
    this.dueDate,
    this.assignedAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        maintenanceRequestId,
        requestNumber,
        property,
        unit,
        taskDetails,
        status,
        statusLabel,
        dueDate,
        assignedAt,
        completedAt,
      ];
}

