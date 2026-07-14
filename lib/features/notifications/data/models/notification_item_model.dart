import '../../domain/entities/notification_item_entity.dart';

class NotificationItemModel extends NotificationItemEntity {
  const NotificationItemModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
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
            : (payload['body']?.toString() ?? payload['message']?.toString() ?? ''));

    final typeStr = json['type']?.toString() ?? payload['type']?.toString() ?? 'general';

    return NotificationItemModel(
      id: json['id']?.toString() ?? '',
      title: titleStr.isNotEmpty ? titleStr : 'تنبيه جديد',
      body: bodyStr,
      type: _simplifyType(typeStr),
      readAt: json['read_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      data: payload,
    );
  }

  static String _simplifyType(String rawType) {
    final lower = rawType.toLowerCase();
    if (lower.contains('payment') || lower.contains('receipt') || lower.contains('invoice') || lower.contains('finance')) {
      return 'payment';
    } else if (lower.contains('lease') || lower.contains('contract') || lower.contains('rent')) {
      return 'lease';
    } else if (lower.contains('maint') || lower.contains('repair') || lower.contains('work_order')) {
      return 'maintenance';
    }
    return 'general';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'read_at': readAt,
      'created_at': createdAt,
      'data': data,
    };
  }
}
