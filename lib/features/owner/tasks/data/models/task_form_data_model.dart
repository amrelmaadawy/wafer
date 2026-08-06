import '../../domain/entities/task_form_data_entity.dart';

class TaskFormDataModel extends TaskFormDataEntity {
  const TaskFormDataModel({
    super.options,
    super.defaults,
    super.validation,
    super.workflow,
  });

  factory TaskFormDataModel.fromJson(Map<String, dynamic> json) {
    return TaskFormDataModel(
      options: json['options'] != null
          ? TaskFormOptionsModel.fromJson(json['options'])
          : null,
      defaults: json['defaults'] != null
          ? TaskFormDefaultsModel.fromJson(json['defaults'])
          : null,
      validation: json['validation'] != null
          ? TaskFormValidationModel.fromJson(json['validation'])
          : null,
      workflow: json['workflow'] != null
          ? TaskFormWorkflowModel.fromJson(json['workflow'])
          : null,
    );
  }
}

class TaskFormOptionsModel extends TaskFormOptionsEntity {
  const TaskFormOptionsModel({
    super.properties,
    super.deeds,
    super.branches,
    super.assignees,
    super.statuses,
    super.kanbanStatuses,
    super.priorities,
    super.categories,
    super.linkedTo,
    super.booleanValues,
  });

  factory TaskFormOptionsModel.fromJson(Map<String, dynamic> json) {
    return TaskFormOptionsModel(
      properties: json['properties'] != null
          ? (json['properties'] as List)
                .map((e) => TaskPropertyOptionModel.fromJson(e))
                .toList()
          : null,
      deeds: json['deeds'] != null
          ? (json['deeds'] as List)
                .map((e) => TaskDeedOptionModel.fromJson(e))
                .toList()
          : null,
      branches: json['branches'] != null
          ? (json['branches'] as List)
                .map((e) => TaskBranchOptionModel.fromJson(e))
                .toList()
          : null,
      assignees: json['assignees'] != null
          ? (json['assignees'] as List)
                .map((e) => TaskAssigneeOptionModel.fromJson(e))
                .toList()
          : null,
      statuses: json['statuses'] != null
          ? (json['statuses'] as List)
                .map((e) => TaskStatusOptionModel.fromJson(e))
                .toList()
          : null,
      kanbanStatuses: json['kanban_statuses'] != null
          ? (json['kanban_statuses'] as List)
                .map((e) => TaskStatusOptionModel.fromJson(e))
                .toList()
          : null,
      priorities: json['priorities'] != null
          ? (json['priorities'] as List)
                .map((e) => TaskStatusOptionModel.fromJson(e))
                .toList()
          : null,
      categories: json['categories'] != null
          ? (json['categories'] as List)
                .map((e) => TaskStatusOptionModel.fromJson(e))
                .toList()
          : null,
      linkedTo: json['linked_to'] != null
          ? (json['linked_to'] as List)
                .map((e) => TaskStatusOptionModel.fromJson(e))
                .toList()
          : null,
      booleanValues: json['boolean_values'] != null
          ? (json['boolean_values'] as List)
                .map((e) => TaskBooleanValueModel.fromJson(e))
                .toList()
          : null,
    );
  }
}

class TaskPropertyOptionModel extends TaskPropertyOptionEntity {
  const TaskPropertyOptionModel({
    super.id,
    super.name,
    super.code,
    super.propertyType,
    super.status,
    super.city,
    super.district,
  });

  factory TaskPropertyOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskPropertyOptionModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      propertyType: json['property_type'],
      status: json['status'],
      city: json['city'],
      district: json['district'],
    );
  }
}

class TaskDeedOptionModel extends TaskDeedOptionEntity {
  const TaskDeedOptionModel({
    super.id,
    super.code,
    super.name,
    super.documentNumber,
    super.city,
    super.district,
  });

  factory TaskDeedOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskDeedOptionModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      documentNumber: json['document_number'],
      city: json['city'],
      district: json['district'],
    );
  }
}

class TaskBranchOptionModel extends TaskBranchOptionEntity {
  const TaskBranchOptionModel({
    super.id,
    super.name,
    super.city,
    super.district,
    super.status,
  });

  factory TaskBranchOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskBranchOptionModel(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      district: json['district'],
      status: json['status'],
    );
  }
}

class TaskAssigneeOptionModel extends TaskAssigneeOptionEntity {
  const TaskAssigneeOptionModel({
    super.id,
    super.name,
    super.email,
    super.phone,
    super.userType,
    super.isActive,
  });

  factory TaskAssigneeOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskAssigneeOptionModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      userType: json['user_type'],
      isActive: json['is_active'],
    );
  }
}

class TaskStatusOptionModel extends TaskStatusOptionEntity {
  const TaskStatusOptionModel({
    super.value,
    super.label,
    super.color,
    super.backgroundColor,
    super.icon,
  });

  factory TaskStatusOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskStatusOptionModel(
      value: json['value'],
      label: json['label'],
      color: json['color'],
      backgroundColor: json['background_color'],
      icon: json['icon'],
    );
  }
}

class TaskBooleanValueModel extends TaskBooleanValueEntity {
  const TaskBooleanValueModel({super.value, super.label});

  factory TaskBooleanValueModel.fromJson(Map<String, dynamic> json) {
    return TaskBooleanValueModel(value: json['value'], label: json['label']);
  }
}

class TaskFormDefaultsModel extends TaskFormDefaultsEntity {
  const TaskFormDefaultsModel({
    super.code,
    super.status,
    super.priority,
    super.progress,
    super.startDate,
    super.dueDate,
    super.maxImages,
    super.allowedImageMimes,
    super.maxImageSizeKb,
  });

  factory TaskFormDefaultsModel.fromJson(Map<String, dynamic> json) {
    return TaskFormDefaultsModel(
      code: json['code'],
      status: json['status'],
      priority: json['priority'],
      progress: json['progress'],
      startDate: json['start_date'],
      dueDate: json['due_date'],
      maxImages: json['max_images'],
      allowedImageMimes: json['allowed_image_mimes'] != null
          ? List<String>.from(json['allowed_image_mimes'])
          : null,
      maxImageSizeKb: json['max_image_size_kb'],
    );
  }
}

class TaskFormValidationModel extends TaskFormValidationEntity {
  const TaskFormValidationModel({
    super.requiredFields,
    super.titleMax,
    super.progressMin,
    super.progressMax,
    super.maxImagesCount,
    super.imageMimes,
    super.imageMaxKb,
  });

  factory TaskFormValidationModel.fromJson(Map<String, dynamic> json) {
    return TaskFormValidationModel(
      requiredFields: json['required'] != null
          ? List<String>.from(json['required'])
          : null,
      titleMax: json['title']?['max'],
      progressMin: json['progress']?['min'],
      progressMax: json['progress']?['max'],
      maxImagesCount: json['images']?['max_count'],
      imageMimes: json['images']?['mimes'] != null
          ? List<String>.from(json['images']['mimes'])
          : null,
      imageMaxKb: json['images']?['max_kb'],
    );
  }
}

class TaskFormWorkflowModel extends TaskFormWorkflowEntity {
  const TaskFormWorkflowModel({super.sequence, super.terminal});

  factory TaskFormWorkflowModel.fromJson(Map<String, dynamic> json) {
    return TaskFormWorkflowModel(
      sequence: json['sequence'] != null
          ? List<String>.from(json['sequence'])
          : null,
      terminal: json['terminal'] != null
          ? List<String>.from(json['terminal'])
          : null,
    );
  }
}
