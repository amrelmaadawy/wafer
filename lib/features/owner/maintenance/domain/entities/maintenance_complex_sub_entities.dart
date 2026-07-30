import 'package:equatable/equatable.dart';

class MaintenancePeopleEntity extends Equatable {
  final int? assignedEmployee;
  final int? supervisor;
  final int? ownerRepresentative;

  const MaintenancePeopleEntity({
    this.assignedEmployee,
    this.supervisor,
    this.ownerRepresentative,
  });

  @override
  List<Object?> get props => [
    assignedEmployee,
    supervisor,
    ownerRepresentative,
  ];
}

class MaintenanceQaEntity extends Equatable {
  final String? confirmedAt;
  final int? confirmedBy;

  const MaintenanceQaEntity({this.confirmedAt, this.confirmedBy});

  @override
  List<Object?> get props => [confirmedAt, confirmedBy];
}

class MaintenanceRatingEntity extends Equatable {
  final int? value;
  final String? comment;

  const MaintenanceRatingEntity({this.value, this.comment});

  @override
  List<Object?> get props => [value, comment];
}

class MaintenanceTechnicianEntity extends Equatable {
  final int? id;
  final String? name;
  final String? phone;
  final String? specialty;
  final String? companyName;

  const MaintenanceTechnicianEntity({
    this.id,
    this.name,
    this.phone,
    this.specialty,
    this.companyName,
  });

  @override
  List<Object?> get props => [id, name, phone, specialty, companyName];
}

class MaintenanceAssignmentEntity extends Equatable {
  final int? id;
  final MaintenanceTechnicianEntity? technician;
  final String? taskDetails;
  final String? status;
  final String? statusLabel;
  final String? dueDate;
  final String? assignedAt;
  final String? completedAt;

  const MaintenanceAssignmentEntity({
    this.id,
    this.technician,
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
    technician,
    taskDetails,
    status,
    statusLabel,
    dueDate,
    assignedAt,
    completedAt,
  ];
}

class MaintenanceTaskEntity extends Equatable {
  final int? id;
  final String? title;
  final String? status;
  final String? technicianResponse;
  final int? responsibleId;
  final String? dueDate;
  final String? completedAt;

  const MaintenanceTaskEntity({
    this.id,
    this.title,
    this.status,
    this.technicianResponse,
    this.responsibleId,
    this.dueDate,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    status,
    technicianResponse,
    responsibleId,
    dueDate,
    completedAt,
  ];
}

class MaintenanceActionLogEntity extends Equatable {
  final int? id;
  final String? action;
  final int? performedBy;
  final String? notes;
  final String? oldStatus;
  final String? newStatus;
  final String? createdAt;

  const MaintenanceActionLogEntity({
    this.id,
    this.action,
    this.performedBy,
    this.notes,
    this.oldStatus,
    this.newStatus,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    action,
    performedBy,
    notes,
    oldStatus,
    newStatus,
    createdAt,
  ];
}
