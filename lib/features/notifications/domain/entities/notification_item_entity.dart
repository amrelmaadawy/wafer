import 'package:equatable/equatable.dart';

enum NotificationCategory {
  financial,
  contracts,
  maintenance,
  tasks,
  legal,
  system;

  static NotificationCategory fromType(String? type) {
    if (type == null) return NotificationCategory.system;
    final lower = type.toLowerCase().trim();
    if (lower.contains('payment') ||
        lower.contains('receipt') ||
        lower.contains('invoice') ||
        lower.contains('finance') ||
        lower.contains('installment')) {
      return NotificationCategory.financial;
    }
    if (lower.contains('lease') ||
        lower.contains('contract') ||
        lower.contains('rent')) {
      return NotificationCategory.contracts;
    }
    if (lower.contains('maint') ||
        lower.contains('repair') ||
        lower.contains('work_order')) {
      return NotificationCategory.maintenance;
    }
    if (lower.contains('task') || lower.contains('todo')) {
      return NotificationCategory.tasks;
    }
    if (lower.contains('legal') ||
        lower.contains('case') ||
        lower.contains('court')) {
      return NotificationCategory.legal;
    }
    return NotificationCategory.system;
  }
}

class NotificationItemEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final String type;
  final String? priority;
  final String? entityType;
  final String? entityId;
  final String? readAt;
  final String createdAt;
  final Map<String, dynamic>? data;

  const NotificationItemEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.priority,
    this.entityType,
    this.entityId,
    this.readAt,
    required this.createdAt,
    this.data,
  });

  bool get isRead => readAt != null && readAt!.isNotEmpty && readAt != 'null';

  NotificationCategory get category => NotificationCategory.fromType(type);

  NotificationItemEntity copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    String? priority,
    String? entityType,
    String? entityId,
    String? readAt,
    String? createdAt,
    Map<String, dynamic>? data,
  }) {
    return NotificationItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        type,
        priority,
        entityType,
        entityId,
        readAt,
        createdAt,
        data,
      ];
}
