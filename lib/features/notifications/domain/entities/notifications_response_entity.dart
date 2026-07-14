import 'package:equatable/equatable.dart';
import 'notification_item_entity.dart';
import 'notification_pagination_meta_entity.dart';

class NotificationsResponseEntity extends Equatable {
  final List<NotificationItemEntity> notifications;
  final NotificationPaginationMetaEntity meta;
  final int unreadCount;

  const NotificationsResponseEntity({
    required this.notifications,
    required this.meta,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, meta, unreadCount];
}
