import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_item_entity.dart';
import '../../domain/entities/notification_pagination_meta_entity.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationItemEntity> notifications;
  final NotificationPaginationMetaEntity meta;
  final int unreadCount;
  final bool isFetchingMore;
  final String activeFilter; // 'all' or 'unread'

  const NotificationsLoaded({
    required this.notifications,
    required this.meta,
    required this.unreadCount,
    this.isFetchingMore = false,
    this.activeFilter = 'all',
  });

  List<NotificationItemEntity> get filteredNotifications {
    if (activeFilter == 'unread') {
      return notifications.where((item) => !item.isRead).toList();
    }
    return notifications;
  }

  NotificationsLoaded copyWith({
    List<NotificationItemEntity>? notifications,
    NotificationPaginationMetaEntity? meta,
    int? unreadCount,
    bool? isFetchingMore,
    String? activeFilter,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      meta: meta ?? this.meta,
      unreadCount: unreadCount ?? this.unreadCount,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  List<Object?> get props => [
        notifications,
        meta,
        unreadCount,
        isFetchingMore,
        activeFilter,
      ];
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationsEmpty extends NotificationsState {
  final String activeFilter;

  const NotificationsEmpty({this.activeFilter = 'all'});

  @override
  List<Object?> get props => [activeFilter];
}
