import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/owner_dashboard_entity.dart';

class OwnerMaintenancePriorityQueue extends StatelessWidget {
  final MaintenanceBreakdownEntity? breakdown;
  final int totalPending;

  const OwnerMaintenancePriorityQueue({
    super.key,
    this.breakdown,
    required this.totalPending,
  });

  @override
  Widget build(BuildContext context) {
    final urgent = breakdown?.urgent ?? 0;
    final newRequests = breakdown?.newRequests ?? 0;
    final inProgress = breakdown?.inProgress ?? 0;

    final headerColor = urgent > 0 ? AppColors.error : AppColors.warning;

    return AppSurfaceCard(
      onTap: () => context.push(Routes.ownerMaintenance),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: headerColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Icon(
                  Icons.precision_manufacturing_rounded,
                  size: 16,
                  color: headerColor,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  LocaleKeys.dashboardMaintenanceQueueTitle.tr(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: context.appOnSurfaceColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: AppRadius.circularFull,
                ),
                child: Text(
                  '$totalPending',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _PriorityMetric(
                  count: urgent,
                  label: LocaleKeys.dashboardMaintenanceUrgent.tr(),
                  color: AppColors.error,
                  icon: Icons.priority_high_rounded,
                  onTap: () => context.push(
                    '${Routes.ownerMaintenance}?filter=urgent',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _PriorityMetric(
                  count: newRequests,
                  label: LocaleKeys.dashboardMaintenanceNew.tr(),
                  color: AppColors.warning,
                  icon: Icons.fiber_new_rounded,
                  onTap: () => context.push(
                    '${Routes.ownerMaintenance}?filter=new',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _PriorityMetric(
                  count: inProgress,
                  label: LocaleKeys.dashboardMaintenanceInProgress.tr(),
                  color: AppColors.info,
                  icon: Icons.pending_rounded,
                  onTap: () => context.push(
                    '${Routes.ownerMaintenance}?filter=in_progress',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriorityMetric extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _PriorityMetric({
    required this.count,
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circularMd,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: AppRadius.circularMd,
          border: Border.all(color: color.withValues(alpha: 0.18), width: 1),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 13),
                const SizedBox(width: 3),
                Text(
                  '$count',
                  style: AppTextStyles.h4.copyWith(
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall.copyWith(
                color: context.appSecondaryTextColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
