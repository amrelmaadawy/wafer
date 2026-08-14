import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';

class ActivityLogsPageHeader extends StatelessWidget {
  const ActivityLogsPageHeader({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.primaryDark, context.primaryColor],
          ),
          borderRadius: AppRadius.circularXl,
          boxShadow: [
            BoxShadow(
              color: context.primaryShadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: AppRadius.circularLg,
              ),
              child: const Icon(
                Icons.manage_history_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.activityLogsTitle.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    LocaleKeys.activityLogsSubtitle.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: context.primaryFaint,
          borderRadius: AppRadius.circularLg,
          border: Border.all(
            color: context.primaryColor.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_outline_rounded, color: context.primaryColor),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                LocaleKeys.activityLogsReadOnlyNotice.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.appSecondaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
