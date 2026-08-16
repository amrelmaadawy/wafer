import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final int id;
  final String? code;
  final String title;
  final String? description;
  final TaskOptionEntity? status;
  final TaskOptionEntity? priority;
  final TaskOptionEntity? category;
  final int progress;
  final TaskDatesEntity? dates;
  final String? notes;
  final TaskLinkedEntity? linkedEntity;
  final TaskBranchEntity? branch;
  final TaskPropertyEntity? property;
  final TaskUnitEntity? unit;
  final TaskContractEntity? contract;
  final TaskDeedEntity? deed;
  final List<TaskAssigneeEntity>? assignees;
  final List<TaskCommentEntity>? comments;
  final List<TaskImageEntity>? images;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;

  const TaskEntity({
    required this.id,
    this.code,
    required this.title,
    this.description,
    this.status,
    this.priority,
    this.category,
    required this.progress,
    this.dates,
    this.notes,
    this.linkedEntity,
    this.branch,
    this.property,
    this.unit,
    this.contract,
    this.deed,
    this.assignees,
    this.comments,
    this.images,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        code,
        title,
        description,
        status,
        priority,
        category,
        progress,
        dates,
        notes,
        linkedEntity,
        branch,
        property,
        unit,
        contract,
        deed,
        assignees,
        comments,
        images,
        createdBy,
        createdAt,
        updatedAt,
      ];
}

class TaskAssigneeEntity extends Equatable {
  final int id;
  final String? name;
  final String? avatar;

  const TaskAssigneeEntity({required this.id, this.name, this.avatar});

  @override
  List<Object?> get props => [id, name, avatar];
}

class TaskCommentEntity extends Equatable {
  final int id;
  final String? content;
  final String? createdAt;
  final TaskAssigneeEntity? user;

  const TaskCommentEntity({required this.id, this.content, this.createdAt, this.user});

  @override
  List<Object?> get props => [id, content, createdAt, user];
}

class TaskImageEntity extends Equatable {
  final int id;
  final String url;

  const TaskImageEntity({required this.id, required this.url});

  @override
  List<Object?> get props => [id, url];
}

class TaskOptionEntity extends Equatable {
  final String value;
  final String label;
  final String? color;
  final String? backgroundColor;
  final String? icon;

  const TaskOptionEntity({
    required this.value,
    required this.label,
    this.color,
    this.backgroundColor,
    this.icon,
  });

  @override
  List<Object?> get props => [value, label, color, backgroundColor, icon];
}

class TaskDatesEntity extends Equatable {
  final String? startDate;
  final String? dueDate;
  final String? completedAt;
  final bool isOverdue;

  const TaskDatesEntity({
    this.startDate,
    this.dueDate,
    this.completedAt,
    required this.isOverdue,
  });

  @override
  List<Object?> get props => [startDate, dueDate, completedAt, isOverdue];
}

class TaskLinkedEntity extends Equatable {
  final int? id;
  final String? type;
  final String? name;

  const TaskLinkedEntity({this.id, this.type, this.name});

  @override
  List<Object?> get props => [id, type, name];
}

class TaskBranchEntity extends Equatable {
  final int id;
  final String? name;
  final String? city;
  final String? district;

  const TaskBranchEntity({required this.id, this.name, this.city, this.district});

  @override
  List<Object?> get props => [id, name, city, district];
}

class TaskPropertyEntity extends Equatable {
  final int id;
  final String? name;
  final String? code;
  final String? propertyType;
  final String? city;
  final String? district;

  const TaskPropertyEntity({
    required this.id,
    this.name,
    this.code,
    this.propertyType,
    this.city,
    this.district,
  });

  @override
  List<Object?> get props => [id, name, code, propertyType, city, district];
}

class TaskUnitEntity extends Equatable {
  final int id;
  final String? name;
  final String? unitNumber;
  final int? propertyId;
  final String? propertyName;

  const TaskUnitEntity({
    required this.id,
    this.name,
    this.unitNumber,
    this.propertyId,
    this.propertyName,
  });

  @override
  List<Object?> get props => [id, name, unitNumber, propertyId, propertyName];
}

class TaskContractEntity extends Equatable {
  final int id;
  final String? contractNumber;
  final String? status;
  final String? renterName;

  const TaskContractEntity({
    required this.id,
    this.contractNumber,
    this.status,
    this.renterName,
  });

  @override
  List<Object?> get props => [id, contractNumber, status, renterName];
}

class TaskDeedEntity extends Equatable {
  final int id;
  final String? name;
  final String? code;
  final String? documentNumber;
  final String? city;
  final String? district;

  const TaskDeedEntity({
    required this.id,
    this.name,
    this.code,
    this.documentNumber,
    this.city,
    this.district,
  });

  @override
  List<Object?> get props => [id, name, code, documentNumber, city, district];
}
