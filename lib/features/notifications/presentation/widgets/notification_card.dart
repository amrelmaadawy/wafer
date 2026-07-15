import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/color_utils.dart';
import '../../domain/entities/notification_item_entity.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItemEntity notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool unread = !notification.isRead;
    final primary = context.primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: unread ? primary.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: unread ? primary.withValues(alpha: 0.25) : const Color(0xFFF1F5F9),
            width: unread ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconBox(context, notification.type),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unread) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: unread ? const Color(0xFF334155) : const Color(0xFF64748B),
                      height: 1.45,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimeAgo(notification.createdAt),
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox(BuildContext context, String type) {
    IconData icon;
    Color bg;
    Color fg;

    switch (type) {
      case 'payment':
        icon = Icons.receipt_long_rounded;
        bg = AppColors.success.withValues(alpha: 0.12);
        fg = AppColors.success;
        break;
      case 'lease':
        icon = Icons.description_outlined;
        bg = context.primaryColor.withValues(alpha: 0.12);
        fg = context.primaryColor;
        break;
      case 'maintenance':
        icon = Icons.build_circle_outlined;
        bg = AppColors.warning.withValues(alpha: 0.14);
        fg = AppColors.warning;
        break;
      default:
        icon = Icons.notifications_outlined;
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: fg, size: 22),
    );
  }

  String _formatTimeAgo(String rawDate) {
    try {
      final date = DateTime.parse(rawDate).toLocal();
      final diff = DateTime.now().difference(date);

      if (diff.inMinutes < 1) {
        return LocaleKeys.notificationsTimeJustNow.tr();
      } else if (diff.inHours < 1) {
        return LocaleKeys.notificationsTimeMinutesAgo.tr(args: ['${diff.inMinutes}']);
      } else if (diff.inDays < 1) {
        return LocaleKeys.notificationsTimeHoursAgo.tr(args: ['${diff.inHours}']);
      } else {
        return LocaleKeys.notificationsTimeDaysAgo.tr(args: ['${diff.inDays}']);
      }
    } catch (_) {
      return LocaleKeys.notificationsTimeJustNow.tr();
    }
  }
}
