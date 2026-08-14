import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/activity_logs_item_entity.dart';
import 'activity_logs_action_style.dart';

class ActivityLogsReportItemCard extends StatelessWidget {
  const ActivityLogsReportItemCard({super.key, required this.item});

  final ActivityLogsItemEntity item;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = activityLogActionStyle(item.action);
    return Card(
      color: context.appSurfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularXl,
        side: BorderSide(color: context.appBorderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: AppRadius.circularLg,
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.message.isEmpty
                        ? LocaleKeys.activityLogsUnknownActivity.tr()
                        : item.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: context.appOnSurfaceColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _ActionBadge(action: item.action, color: color),
              ],
            ),
            if (item.description?.isNotEmpty == true) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                item.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.appSecondaryTextColor,
                ),
              ),
            ],
            const Spacer(),
            Divider(color: context.appBorderColor, height: 1),
            const SizedBox(height: AppSpacing.sm),
            _InfoLine(
              icon: Icons.person_outline_rounded,
              value: item.user.name.isEmpty
                  ? LocaleKeys.activityLogsUnknownUser.tr()
                  : item.user.name,
              trailing: item.user.userType,
            ),
            const SizedBox(height: AppSpacing.xs),
            _InfoLine(
              icon: Icons.schedule_rounded,
              value: item.createdAt,
              trailing: item.ipAddress,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBadge extends StatelessWidget {
  const _ActionBadge({required this.action, required this.color});
  final String action;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.xs,
      vertical: AppSpacing.xxs,
    ),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: AppRadius.circularFull,
    ),
    child: Text(
      action.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.value, this.trailing});
  final IconData icon;
  final String value;
  final String? trailing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: context.appSecondaryTextColor),
      const SizedBox(width: AppSpacing.xs),
      Expanded(
        child: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      if (trailing?.isNotEmpty == true)
        Text(
          trailing!,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: context.appSecondaryTextColor,
          ),
        ),
    ],
  );
}
