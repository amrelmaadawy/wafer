import '../../domain/entities/notifications_response_entity.dart';
import 'notification_item_model.dart';
import 'notification_pagination_meta_model.dart';

class NotificationsResponseModel extends NotificationsResponseEntity {
  const NotificationsResponseModel({
    required super.notifications,
    required super.meta,
    required super.unreadCount,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    // If json has top-level 'data' wrapper, unwrap it
    final Map<String, dynamic> dataMap = json.containsKey('notifications')
        ? json
        : (json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json);

    final notificationsBlock = dataMap['notifications'] is Map<String, dynamic>
        ? dataMap['notifications'] as Map<String, dynamic>
        : <String, dynamic>{};

    final rawList = notificationsBlock['data'] is List
        ? notificationsBlock['data'] as List
        : <dynamic>[];

    final items = rawList
        .whereType<Map<String, dynamic>>()
        .map((e) => NotificationItemModel.fromJson(e))
        .toList();

    final metaMap = notificationsBlock['meta'] is Map<String, dynamic>
        ? notificationsBlock['meta'] as Map<String, dynamic>
        : <String, dynamic>{
            'current_page': 1,
            'last_page': 1,
            'per_page': 20,
            'total': items.length,
          };

    final metaModel = NotificationPaginationMetaModel.fromJson(metaMap);
    final unread = dataMap['unread_count'] as int? ?? 0;

    return NotificationsResponseModel(
      notifications: items,
      meta: metaModel,
      unreadCount: unread,
    );
  }
}
