import '../../domain/entities/task_form_data_entity.dart';

class TaskFormDataModel extends TaskFormDataEntity {
  const TaskFormDataModel({
    required super.options,
    required super.defaults,
    required super.workflow,
  });

  factory TaskFormDataModel.fromJson(Map<String, dynamic> json) {
    return TaskFormDataModel(
      options: TaskOptionsModel.fromJson(json['options'] ?? {}),
      defaults: TaskDefaultsModel.fromJson(json['defaults'] ?? {}),
      workflow: TaskWorkflowModel.fromJson(json['workflow'] ?? {}),
    );
  }
}

class TaskOptionsModel extends TaskOptionsEntity {
  const TaskOptionsModel({
    required super.properties,
    required super.deeds,
    required super.branches,
    required super.assignees,
    required super.statuses,
    required super.kanbanStatuses,
    required super.priorities,
    required super.categories,
    required super.linkedTo,
  });

  factory TaskOptionsModel.fromJson(Map<String, dynamic> json) {
    return TaskOptionsModel(
      properties: (json['properties'] as List?)
              ?.map((e) => TaskPropertyOptionModel.fromJson(e))
              .toList() ??
          [],
      deeds: (json['deeds'] as List?)
              ?.map((e) => TaskDeedOptionModel.fromJson(e))
              .toList() ??
          [],
      branches: (json['branches'] as List?)
              ?.map((e) => TaskBranchOptionModel.fromJson(e))
              .toList() ??
          [],
      assignees: (json['assignees'] as List?)
              ?.map((e) => TaskAssigneeOptionModel.fromJson(e))
              .toList() ??
          [],
      statuses: (json['statuses'] as List?)
              ?.map((e) => TaskStatusOptionModel.fromJson(e))
              .toList() ??
          [],
      kanbanStatuses: (json['kanban_statuses'] as List?)
              ?.map((e) => TaskStatusOptionModel.fromJson(e))
              .toList() ??
          [],
      priorities: (json['priorities'] as List?)
              ?.map((e) => TaskPriorityOptionModel.fromJson(e))
              .toList() ??
          [],
      categories: (json['categories'] as List?)
              ?.map((e) => TaskCategoryOptionModel.fromJson(e))
              .toList() ??
          [],
      linkedTo: (json['linked_to'] as List?)
              ?.map((e) => TaskLinkedToOptionModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TaskPropertyOptionModel extends TaskPropertyOptionEntity {
  const TaskPropertyOptionModel({
    required super.id,
    required super.code,
    super.name,
    super.propertyType,
    super.branchId,
    super.deedId,
  });

  factory TaskPropertyOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskPropertyOptionModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String?,
      propertyType: json['property_type'] as String?,
      branchId: json['branch_id'] as int?,
      deedId: json['deed_id'] as int?,
    );
  }
}

class TaskDeedOptionModel extends TaskDeedOptionEntity {
  const TaskDeedOptionModel({
    required super.id,
    required super.code,
    super.name,
    super.documentNumber,
    super.branchId,
    super.propertyId,
  });

  factory TaskDeedOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskDeedOptionModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String?,
      documentNumber: json['document_number'] as String?,
      branchId: json['branch_id'] as int?,
      propertyId: json['property_id'] as int?,
    );
  }
}

class TaskBranchOptionModel extends TaskBranchOptionEntity {
  const TaskBranchOptionModel({
    required super.id,
    required super.name,
  });

  factory TaskBranchOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskBranchOptionModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class TaskAssigneeOptionModel extends TaskAssigneeOptionEntity {
  const TaskAssigneeOptionModel({
    required super.id,
    required super.name,
    super.email,
    super.phone,
  });

  factory TaskAssigneeOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskAssigneeOptionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }
}

class TaskStatusOptionModel extends TaskStatusOptionEntity {
  const TaskStatusOptionModel({
    required super.value,
    required super.label,
    super.color,
    super.icon,
  });

  factory TaskStatusOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskStatusOptionModel(
      value: json['value'] as String,
      label: json['label'] as String,
      color: json['color'] as String?,
      icon: json['icon'] as String?,
    );
  }
}

class TaskPriorityOptionModel extends TaskPriorityOptionEntity {
  const TaskPriorityOptionModel({
    required super.value,
    required super.label,
    super.color,
    super.icon,
  });

  factory TaskPriorityOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskPriorityOptionModel(
      value: json['value'] as String,
      label: json['label'] as String,
      color: json['color'] as String?,
      icon: json['icon'] as String?,
    );
  }
}

class TaskCategoryOptionModel extends TaskCategoryOptionEntity {
  const TaskCategoryOptionModel({
    required super.value,
    required super.label,
    super.color,
    super.icon,
  });

  factory TaskCategoryOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskCategoryOptionModel(
      value: json['value'] as String,
      label: json['label'] as String,
      color: json['color'] as String?,
      icon: json['icon'] as String?,
    );
  }
}

class TaskLinkedToOptionModel extends TaskLinkedToOptionEntity {
  const TaskLinkedToOptionModel({
    required super.value,
    required super.label,
  });

  factory TaskLinkedToOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskLinkedToOptionModel(
      value: json['value'] as String,
      label: json['label'] as String,
    );
  }
}

class TaskDefaultsModel extends TaskDefaultsEntity {
  const TaskDefaultsModel({
    super.status,
    super.priority,
    super.progress,
    super.maxImages,
    super.allowedImageMimes = const [],
    super.maxImageSizeKb,
  });

  factory TaskDefaultsModel.fromJson(Map<String, dynamic> json) {
    return TaskDefaultsModel(
      status: json['status'] as String?,
      priority: json['priority'] as String?,
      progress: json['progress'] as int?,
      maxImages: json['max_images'] as int?,
      allowedImageMimes: (json['allowed_image_mimes'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      maxImageSizeKb: json['max_image_size_kb'] as int?,
    );
  }
}

class TaskWorkflowModel extends TaskWorkflowEntity {
  const TaskWorkflowModel({
    required super.sequence,
    required super.terminal,
  });

  factory TaskWorkflowModel.fromJson(Map<String, dynamic> json) {
    return TaskWorkflowModel(
      sequence:
          (json['sequence'] as List?)?.map((e) => e as String).toList() ?? [],
      terminal:
          (json['terminal'] as List?)?.map((e) => e as String).toList() ?? [],
    );
  }
}
