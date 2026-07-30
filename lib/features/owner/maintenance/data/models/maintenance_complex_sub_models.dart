import '../../domain/entities/maintenance_complex_sub_entities.dart';

class MaintenancePeopleModel extends MaintenancePeopleEntity {
  const MaintenancePeopleModel({
    super.assignedEmployee,
    super.supervisor,
    super.ownerRepresentative,
  });

  factory MaintenancePeopleModel.fromJson(Map<String, dynamic> json) {
    return MaintenancePeopleModel(
      assignedEmployee: json['assigned_employee'] as int?,
      supervisor: json['supervisor'] as int?,
      ownerRepresentative: json['owner_representative'] as int?,
    );
  }
}

class MaintenanceQaModel extends MaintenanceQaEntity {
  const MaintenanceQaModel({super.confirmedAt, super.confirmedBy});

  factory MaintenanceQaModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceQaModel(
      confirmedAt: json['confirmed_at'] as String?,
      confirmedBy: json['confirmed_by']?.toString(),
    );
  }
}

class MaintenanceRatingModel extends MaintenanceRatingEntity {
  const MaintenanceRatingModel({super.value, super.comment});

  factory MaintenanceRatingModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceRatingModel(
      value: json['value'] as int?,
      comment: json['comment'] as String?,
    );
  }
}

class MaintenanceTechnicianModel extends MaintenanceTechnicianEntity {
  const MaintenanceTechnicianModel({
    super.id,
    super.name,
    super.phone,
    super.specialty,
    super.companyName,
  });

  factory MaintenanceTechnicianModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceTechnicianModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      specialty: json['specialty'] as String?,
      companyName: json['company_name'] as String?,
    );
  }
}

class MaintenanceAssignmentModel extends MaintenanceAssignmentEntity {
  const MaintenanceAssignmentModel({
    super.id,
    super.technician,
    super.taskDetails,
    super.status,
    super.statusLabel,
    super.dueDate,
    super.assignedAt,
    super.completedAt,
  });

  factory MaintenanceAssignmentModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceAssignmentModel(
      id: json['id'] as int?,
      technician: json['technician'] != null
          ? MaintenanceTechnicianModel.fromJson(json['technician'])
          : null,
      taskDetails: json['task_details'] as String?,
      status: json['status'] as String?,
      statusLabel: json['status_label'] as String?,
      dueDate: json['due_date'] as String?,
      assignedAt: json['assigned_at'] as String?,
      completedAt: json['completed_at'] as String?,
    );
  }
}

class MaintenanceTaskModel extends MaintenanceTaskEntity {
  const MaintenanceTaskModel({
    super.id,
    super.title,
    super.status,
    super.technicianResponse,
    super.responsibleId,
    super.dueDate,
    super.completedAt,
  });

  factory MaintenanceTaskModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceTaskModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      status: json['status'] as String?,
      technicianResponse: json['technician_response'] as String?,
      responsibleId: json['responsible_id'] as int?,
      dueDate: json['due_date'] as String?,
      completedAt: json['completed_at'] as String?,
    );
  }
}

class MaintenanceActionLogModel extends MaintenanceActionLogEntity {
  const MaintenanceActionLogModel({
    super.id,
    super.action,
    super.performedBy,
    super.notes,
    super.oldStatus,
    super.newStatus,
    super.createdAt,
  });

  factory MaintenanceActionLogModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceActionLogModel(
      id: json['id'] as int?,
      action: json['action'] as String?,
      performedBy: json['performed_by'] as int?,
      notes: json['notes'] as String?,
      oldStatus: json['old_status'] as String?,
      newStatus: json['new_status'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}
