import 'package:equatable/equatable.dart';

class TaskFormDataEntity extends Equatable {
  final TaskOptionsEntity options;
  final TaskDefaultsEntity defaults;
  final TaskWorkflowEntity workflow;

  const TaskFormDataEntity({
    required this.options,
    required this.defaults,
    required this.workflow,
  });

  @override
  List<Object?> get props => [options, defaults, workflow];
}

class TaskOptionsEntity extends Equatable {
  final List<TaskPropertyOptionEntity> properties;
  final List<TaskDeedOptionEntity> deeds;
  final List<TaskBranchOptionEntity> branches;
  final List<TaskAssigneeOptionEntity> assignees;
  final List<TaskStatusOptionEntity> statuses;
  final List<TaskStatusOptionEntity> kanbanStatuses;
  final List<TaskPriorityOptionEntity> priorities;
  final List<TaskCategoryOptionEntity> categories;
  final List<TaskLinkedToOptionEntity> linkedTo;

  const TaskOptionsEntity({
    required this.properties,
    required this.deeds,
    required this.branches,
    required this.assignees,
    required this.statuses,
    required this.kanbanStatuses,
    required this.priorities,
    required this.categories,
    required this.linkedTo,
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
      ];
}

class TaskPropertyOptionEntity extends Equatable {
  final int id;
  final String code;
  final String? name;
  final String? propertyType;
  final int? branchId;
  final int? deedId;

  const TaskPropertyOptionEntity({
    required this.id,
    required this.code,
    this.name,
    this.propertyType,
    this.branchId,
    this.deedId,
  });

  @override
  List<Object?> get props => [id, code, name, propertyType, branchId, deedId];
}

class TaskDeedOptionEntity extends Equatable {
  final int id;
  final String code;
  final String? name;
  final String? documentNumber;
  final int? branchId;
  final int? propertyId;

  const TaskDeedOptionEntity({
    required this.id,
    required this.code,
    this.name,
    this.documentNumber,
    this.branchId,
    this.propertyId,
  });

  @override
  List<Object?> get props => [id, code, name, documentNumber, branchId, propertyId];
}

class TaskBranchOptionEntity extends Equatable {
  final int id;
  final String name;

  const TaskBranchOptionEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

class TaskAssigneeOptionEntity extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;

  const TaskAssigneeOptionEntity({
    required this.id,
    required this.name,
    this.email,
    this.phone,
  });

  @override
  List<Object?> get props => [id, name, email, phone];
}

class TaskStatusOptionEntity extends Equatable {
  final String value;
  final String label;
  final String? color;
  final String? icon;

  const TaskStatusOptionEntity({
    required this.value,
    required this.label,
    this.color,
    this.icon,
  });

  @override
  List<Object?> get props => [value, label, color, icon];
}

class TaskPriorityOptionEntity extends Equatable {
  final String value;
  final String label;
  final String? color;
  final String? icon;

  const TaskPriorityOptionEntity({
    required this.value,
    required this.label,
    this.color,
    this.icon,
  });

  @override
  List<Object?> get props => [value, label, color, icon];
}

class TaskCategoryOptionEntity extends Equatable {
  final String value;
  final String label;
  final String? color;
  final String? icon;

  const TaskCategoryOptionEntity({
    required this.value,
    required this.label,
    this.color,
    this.icon,
  });

  @override
  List<Object?> get props => [value, label, color, icon];
}

class TaskLinkedToOptionEntity extends Equatable {
  final String value;
  final String label;

  const TaskLinkedToOptionEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}

class TaskDefaultsEntity extends Equatable {
  final String? status;
  final String? priority;
  final int? progress;
  final int? maxImages;
  final List<String> allowedImageMimes;
  final int? maxImageSizeKb;

  const TaskDefaultsEntity({
    this.status,
    this.priority,
    this.progress,
    this.maxImages,
    this.allowedImageMimes = const [],
    this.maxImageSizeKb,
  });

  @override
  List<Object?> get props => [
        status,
        priority,
        progress,
        maxImages,
        allowedImageMimes,
        maxImageSizeKb,
      ];
}

class TaskWorkflowEntity extends Equatable {
  final List<String> sequence;
  final List<String> terminal;

  const TaskWorkflowEntity({
    required this.sequence,
    required this.terminal,
  });

  @override
  List<Object?> get props => [sequence, terminal];
}
