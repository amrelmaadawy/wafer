import '../../domain/entities/task_entity.dart';
import '../../domain/entities/tasks_pagination_meta_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    super.code,
    required super.title,
    super.description,
    super.status,
    super.priority,
    super.category,
    required super.progress,
    super.dates,
    super.notes,
    super.linkedEntity,
    super.branch,
    super.property,
    super.deed,
    super.assignees,
    super.comments,
    super.images,
    super.createdBy,
    super.createdAt,
    super.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      code: json['code'],
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] != null ? TaskOptionModel.fromJson(json['status']) : null,
      priority: json['priority'] != null ? TaskOptionModel.fromJson(json['priority']) : null,
      category: json['category'] != null ? TaskOptionModel.fromJson(json['category']) : null,
      progress: json['progress'] ?? 0,
      dates: json['dates'] != null ? TaskDatesModel.fromJson(json['dates']) : null,
      notes: json['notes'],
      linkedEntity: json['linked_entity'] != null ? TaskLinkedModel.fromJson(json['linked_entity']) : null,
      branch: json['branch'] != null ? TaskBranchModel.fromJson(json['branch']) : null,
      property: json['property'] != null ? TaskPropertyModel.fromJson(json['property']) : null,
      deed: json['deed'] != null ? TaskDeedModel.fromJson(json['deed']) : null,
      assignees: json['assignees'] != null
          ? (json['assignees'] as List).map((e) => TaskAssigneeModel.fromJson(e)).toList()
          : null,
      comments: json['comments'] != null
          ? (json['comments'] as List).map((e) => TaskCommentModel.fromJson(e)).toList()
          : null,
      images: json['images'] != null
          ? (json['images'] as List).map((e) => TaskImageModel.fromJson(e)).toList()
          : null,
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class TaskAssigneeModel extends TaskAssigneeEntity {
  const TaskAssigneeModel({
    required super.id,
    super.name,
    super.avatar,
  });

  factory TaskAssigneeModel.fromJson(Map<String, dynamic> json) {
    return TaskAssigneeModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}

class TaskCommentModel extends TaskCommentEntity {
  const TaskCommentModel({
    required super.id,
    super.content,
    super.createdAt,
    super.user,
  });

  factory TaskCommentModel.fromJson(Map<String, dynamic> json) {
    return TaskCommentModel(
      id: json['id'],
      content: json['content'],
      createdAt: json['created_at'],
      user: json['user'] != null ? TaskAssigneeModel.fromJson(json['user']) : null,
    );
  }
}

class TaskImageModel extends TaskImageEntity {
  const TaskImageModel({
    required super.id,
    required super.url,
  });

  factory TaskImageModel.fromJson(Map<String, dynamic> json) {
    return TaskImageModel(
      id: json['id'],
      url: json['url'] ?? '',
    );
  }
}

class TaskOptionModel extends TaskOptionEntity {
  const TaskOptionModel({
    required super.value,
    required super.label,
    super.color,
    super.backgroundColor,
    super.icon,
  });

  factory TaskOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskOptionModel(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
      color: json['color'],
      backgroundColor: json['background_color'],
      icon: json['icon'],
    );
  }
}

class TaskDatesModel extends TaskDatesEntity {
  const TaskDatesModel({
    super.startDate,
    super.dueDate,
    super.completedAt,
    required super.isOverdue,
  });

  factory TaskDatesModel.fromJson(Map<String, dynamic> json) {
    return TaskDatesModel(
      startDate: json['start_date'],
      dueDate: json['due_date'],
      completedAt: json['completed_at'],
      isOverdue: json['is_overdue'] ?? false,
    );
  }
}

class TaskLinkedModel extends TaskLinkedEntity {
  const TaskLinkedModel({super.type, super.name});

  factory TaskLinkedModel.fromJson(Map<String, dynamic> json) {
    return TaskLinkedModel(
      type: json['type'],
      name: json['name'],
    );
  }
}

class TaskBranchModel extends TaskBranchEntity {
  const TaskBranchModel({required super.id, super.name, super.city, super.district});

  factory TaskBranchModel.fromJson(Map<String, dynamic> json) {
    return TaskBranchModel(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      district: json['district'],
    );
  }
}

class TaskPropertyModel extends TaskPropertyEntity {
  const TaskPropertyModel({
    required super.id,
    super.name,
    super.code,
    super.propertyType,
    super.city,
    super.district,
  });

  factory TaskPropertyModel.fromJson(Map<String, dynamic> json) {
    return TaskPropertyModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      propertyType: json['property_type'],
      city: json['city'],
      district: json['district'],
    );
  }
}

class TaskDeedModel extends TaskDeedEntity {
  const TaskDeedModel({
    required super.id,
    super.name,
    super.code,
    super.documentNumber,
    super.city,
    super.district,
  });

  factory TaskDeedModel.fromJson(Map<String, dynamic> json) {
    return TaskDeedModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      documentNumber: json['document_number'],
      city: json['city'],
      district: json['district'],
    );
  }
}

class TasksPaginationMetaModel extends TasksPaginationMetaEntity {
  const TasksPaginationMetaModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory TasksPaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return TasksPaginationMetaModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}
