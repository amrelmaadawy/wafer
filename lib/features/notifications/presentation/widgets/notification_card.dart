import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wafer/core/theme/app_radius.dart';
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
      borderRadius: AppRadius.circularXl,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: unread ? primary.withValues(alpha: 0.04) : Colors.white,
          borderRadius: AppRadius.circularXl,
          border: Border.all(
            color: unread
                ? primary.withValues(alpha: 0.25)
                : AppColors.dividerSubtleLight,
            width: unread ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconBox(context, notification.category),
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
                            fontWeight: unread
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: AppColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (notification.priority != null &&
                          notification.priority!.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        _buildPriorityBadge(notification.priority!),
                      ],
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
                  if (notification.body.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      notification.body,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondaryLight,
                        height: 1.45,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: AppColors.textTertiaryLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimeAgo(notification.createdAt),
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textTertiaryLight,
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

  Widget _buildIconBox(BuildContext context, NotificationCategory category) {
    IconData icon;
    Color bg;
    Color fg;

    switch (category) {
      case NotificationCategory.financial:
        icon = Icons.receipt_long_rounded;
        bg = AppColors.success.withValues(alpha: 0.12);
        fg = AppColors.success;
        break;
      case NotificationCategory.contracts:
        icon = Icons.description_outlined;
        bg = context.primaryColor.withValues(alpha: 0.12);
        fg = context.primaryColor;
        break;
      case NotificationCategory.maintenance:
        icon = Icons.build_circle_outlined;
        bg = AppColors.warning.withValues(alpha: 0.14);
        fg = AppColors.warning;
        break;
      case NotificationCategory.tasks:
        icon = Icons.task_alt_rounded;
        bg = AppColors.info.withValues(alpha: 0.12);
        fg = AppColors.info;
        break;
      case NotificationCategory.legal:
        icon = Icons.gavel_rounded;
        bg = AppColors.error.withValues(alpha: 0.12);
        fg = AppColors.error;
        break;
      case NotificationCategory.system:
        icon = Icons.notifications_outlined;
        bg = AppColors.dividerSubtleLight;
        fg = AppColors.textSecondaryLight;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.circularLg,
      ),
      child: Icon(icon, color: fg, size: 22),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    final lower = priority.toLowerCase();
    Color color = AppColors.info;
    String label = LocaleKeys.notificationPriorityLow.tr();

    if (lower == 'high' || lower == 'urgent') {
      color = AppColors.error;
      label = LocaleKeys.notificationPriorityHigh.tr();
    } else if (lower == 'medium' || lower == 'normal') {
      color = AppColors.warning;
      label = LocaleKeys.notificationPriorityMedium.tr();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.circularSm,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatTimeAgo(String rawDate) {
    try {
      final date = DateTime.parse(rawDate).toLocal();
      final diff = DateTime.now().difference(date);

      if (diff.inMinutes < 1) {
        return LocaleKeys.notificationsTimeJustNow.tr();
      } else if (diff.inHours < 1) {
        return LocaleKeys.notificationsTimeMinutesAgo.tr(
          args: ['${diff.inMinutes}'],
        );
      } else if (diff.inDays < 1) {
        return LocaleKeys.notificationsTimeHoursAgo.tr(
          args: ['${diff.inHours}'],
        );
      } else {
        return LocaleKeys.notificationsTimeDaysAgo.tr(args: ['${diff.inDays}']);
      }
    } catch (_) {
      return LocaleKeys.notificationsTimeJustNow.tr();
    }
  }
}
