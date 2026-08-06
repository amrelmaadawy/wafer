import 'package:equatable/equatable.dart';

class TaskFormDataEntity extends Equatable {
  final TaskFormOptionsEntity? options;
  final TaskFormDefaultsEntity? defaults;
  final TaskFormValidationEntity? validation;
  final TaskFormWorkflowEntity? workflow;

  const TaskFormDataEntity({
    this.options,
    this.defaults,
    this.validation,
    this.workflow,
  });

  @override
  List<Object?> get props => [options, defaults, validation, workflow];
}

class TaskFormOptionsEntity extends Equatable {
  final List<TaskPropertyOptionEntity>? properties;
  final List<TaskDeedOptionEntity>? deeds;
  final List<TaskBranchOptionEntity>? branches;
  final List<TaskAssigneeOptionEntity>? assignees;
  final List<TaskStatusOptionEntity>? statuses;
  final List<TaskStatusOptionEntity>? kanbanStatuses;
  final List<TaskStatusOptionEntity>? priorities;
  final List<TaskStatusOptionEntity>? categories;
  final List<TaskStatusOptionEntity>? linkedTo;
  final List<TaskBooleanValueEntity>? booleanValues;

  const TaskFormOptionsEntity({
    this.properties,
    this.deeds,
    this.branches,
    this.assignees,
    this.statuses,
    this.kanbanStatuses,
    this.priorities,
    this.categories,
    this.linkedTo,
    this.booleanValues,
  });

  @override
  List<Object?> get props => [
    properties,
    deeds,
    branches,
    assignees,
    statuses,
    kanbanStatuses,
    priorities,
    categories,
    linkedTo,
    booleanValues,
  ];
}

class TaskPropertyOptionEntity extends Equatable {
  final int? id;
  final String? name;
  final String? code;
  final String? propertyType;
  final String? status;
  final String? city;
  final String? district;

  const TaskPropertyOptionEntity({
    this.id,
    this.name,
    this.code,
    this.propertyType,
    this.status,
    this.city,
    this.district,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    propertyType,
    status,
    city,
    district,
  ];
}

class TaskDeedOptionEntity extends Equatable {
  final int? id;
  final String? code;
  final String? name;
  final String? documentNumber;
  final String? city;
  final String? district;

  const TaskDeedOptionEntity({
    this.id,
    this.code,
    this.name,
    this.documentNumber,
    this.city,
    this.district,
  });

  @override
  List<Object?> get props => [id, code, name, documentNumber, city, district];
}

class TaskBranchOptionEntity extends Equatable {
  final int? id;
  final String? name;
  final String? city;
  final String? district;
  final String? status;

  const TaskBranchOptionEntity({
    this.id,
    this.name,
    this.city,
    this.district,
    this.status,
  });

  @override
  List<Object?> get props => [id, name, city, district, status];
}

class TaskAssigneeOptionEntity extends Equatable {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? userType;
  final bool? isActive;

  const TaskAssigneeOptionEntity({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.userType,
    this.isActive,
  });

  @override
  List<Object?> get props => [id, name, email, phone, userType, isActive];
}

class TaskStatusOptionEntity extends Equatable {
  final String? value;
  final String? label;
  final String? color;
  final String? backgroundColor;
  final String? icon;

  const TaskStatusOptionEntity({
    this.value,
    this.label,
    this.color,
    this.backgroundColor,
    this.icon,
  });

  @override
  List<Object?> get props => [value, label, color, backgroundColor, icon];
}

class TaskBooleanValueEntity extends Equatable {
  final bool? value;
  final String? label;

  const TaskBooleanValueEntity({this.value, this.label});

  @override
  List<Object?> get props => [value, label];
}

class TaskFormDefaultsEntity extends Equatable {
  final String? code;
  final String? status;
  final String? priority;
  final int? progress;
  final String? startDate;
  final String? dueDate;
  final int? maxImages;
  final List<String>? allowedImageMimes;
  final int? maxImageSizeKb;

  const TaskFormDefaultsEntity({
    this.code,
    this.status,
    this.priority,
    this.progress,
    this.startDate,
    this.dueDate,
    this.maxImages,
    this.allowedImageMimes,
    this.maxImageSizeKb,
  });

  @override
  List<Object?> get props => [
    code,
    status,
    priority,
    progress,
    startDate,
    dueDate,
    maxImages,
    allowedImageMimes,
    maxImageSizeKb,
  ];
}

class TaskFormValidationEntity extends Equatable {
  final List<String>? requiredFields;
  final int? titleMax;
  final int? progressMin;
  final int? progressMax;
  final int? maxImagesCount;
  final List<String>? imageMimes;
  final int? imageMaxKb;

  const TaskFormValidationEntity({
    this.requiredFields,
    this.titleMax,
    this.progressMin,
    this.progressMax,
    this.maxImagesCount,
    this.imageMimes,
    this.imageMaxKb,
  });

  @override
  List<Object?> get props => [
    requiredFields,
    titleMax,
    progressMin,
    progressMax,
    maxImagesCount,
    imageMimes,
    imageMaxKb,
  ];
}

class TaskFormWorkflowEntity extends Equatable {
  final List<String>? sequence;
  final List<String>? terminal;

  const TaskFormWorkflowEntity({this.sequence, this.terminal});

  @override
  List<Object?> get props => [sequence, terminal];
}
