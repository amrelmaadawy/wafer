import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';

class OwnerQuickActions extends StatelessWidget {
  const OwnerQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.grid_view_rounded,
              size: 15,
              color: context.appSecondaryTextColor,
            ),
            const SizedBox(width: 5),
            Text(
              LocaleKeys.dashboard_quick_actions.tr(),
              style: AppTextStyles.labelLarge.copyWith(
                color: context.appOnSurfaceColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _QuickActionTile(
                icon: Icons.build_circle_outlined,
                label: LocaleKeys.maintenance_title.tr(),
                color: AppColors.error,
                onTap: () => context.push(Routes.ownerMaintenance),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _QuickActionTile(
                icon: Icons.bar_chart_rounded,
                label: LocaleKeys.dashboard_reports.tr(),
                color: AppColors.warning,
                onTap: () =>
                    context.push('${Routes.ownerReportsCenter}?tab=0'),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _QuickActionTile(
                icon: Icons.task_rounded,
                label: LocaleKeys.dashboard_tasks.tr(),
                color: AppColors.accent,
                onTap: () => context.push(Routes.ownerTasks),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _QuickActionTile(
                icon: Icons.gavel_rounded,
                label: LocaleKeys.legalCasesTitle.tr(),
                color: AppColors.info,
                onTap: () => context.push(Routes.ownerLegalCases),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadius.circularXl,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circularXl,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: context.appSurfaceColor,
            borderRadius: AppRadius.circularXl,
            border: Border.all(color: color.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelSmall.copyWith(
                  color: context.appOnSurfaceColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
