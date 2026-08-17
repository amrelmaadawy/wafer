import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../domain/entities/notification_item_entity.dart';

class NotificationItemModel extends NotificationItemEntity {
  const NotificationItemModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    super.priority,
    super.entityType,
    super.entityId,
    super.readAt,
    required super.createdAt,
    super.data,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    final titleStr = json['title']?.toString().isNotEmpty == true
        ? json['title'].toString()
        : (payload['title']?.toString() ?? '');

    final bodyStr = json['body']?.toString().isNotEmpty == true
        ? json['body'].toString()
        : (json['message']?.toString().isNotEmpty == true
            ? json['message'].toString()
            : (payload['body']?.toString() ??
                payload['message']?.toString() ??
                ''));

    final typeStr =
        json['type']?.toString() ?? payload['type']?.toString() ?? 'system';

    final priorityStr =
        json['priority']?.toString() ?? payload['priority']?.toString();

    final entityTypeStr = json['entity_type']?.toString() ??
        payload['entity_type']?.toString() ??
        payload['model']?.toString();

    final entityIdStr = json['entity_id']?.toString() ??
        payload['entity_id']?.toString() ??
        payload['id']?.toString() ??
        payload['contract_id']?.toString() ??
        payload['maintenance_id']?.toString() ??
        payload['case_id']?.toString() ??
        payload['task_id']?.toString();

    return NotificationItemModel(
      id: json['id']?.toString() ?? '',
      title: titleStr.isNotEmpty
          ? titleStr
          : LocaleKeys.notificationsDefaultTitle.tr(),
      body: bodyStr,
      type: _simplifyType(typeStr),
      priority: priorityStr,
      entityType: entityTypeStr,
      entityId: entityIdStr,
      readAt: json['read_at']?.toString(),
      createdAt:
          json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      data: payload,
    );
  }

  static String _simplifyType(String rawType) {
    final lower = rawType.toLowerCase();
    if (lower.contains('payment') ||
        lower.contains('receipt') ||
        lower.contains('invoice') ||
        lower.contains('finance') ||
        lower.contains('installment')) {
      return 'payment';
    } else if (lower.contains('lease') ||
        lower.contains('contract') ||
        lower.contains('rent')) {
      return 'lease';
    } else if (lower.contains('maint') ||
        lower.contains('repair') ||
        lower.contains('work_order')) {
      return 'maintenance';
    } else if (lower.contains('task') || lower.contains('todo')) {
      return 'task';
    } else if (lower.contains('legal') ||
        lower.contains('case') ||
        lower.contains('court')) {
      return 'legal';
    }
    return 'system';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'priority': priority,
      'entity_type': entityType,
      'entity_id': entityId,
      'read_at': readAt,
      'created_at': createdAt,
      'data': data,
    };
  }
}
