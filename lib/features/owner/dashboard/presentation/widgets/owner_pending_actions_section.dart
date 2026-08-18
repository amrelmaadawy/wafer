import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/owner_dashboard_entity.dart';

class OwnerPendingActionsSection extends StatelessWidget {
  final OwnerDashboardEntity data;

  const OwnerPendingActionsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final actions = _buildActionCards(context);
    if (actions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.pending_actions_rounded,
              size: 15,
              color: context.primaryColor,
            ),
            const SizedBox(width: 5),
            Text(
              LocaleKeys.dashboardPendingActionsTitle.tr(),
              style: AppTextStyles.labelLarge.copyWith(
                color: context.appOnSurfaceColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Text(
              LocaleKeys.dashboardPendingActionsSub.tr(),
              style: AppTextStyles.labelSmall.copyWith(
                color: context.appSecondaryTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (var i = 0; i < actions.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.xs),
          actions[i],
        ],
      ],
    );
  }

  List<Widget> _buildActionCards(BuildContext context) {
    final items = <Widget>[];

    final newMaint = data.maintenanceBreakdown?.newRequests ?? 0;
    if (newMaint > 0) {
      items.add(_ActionTile(
        icon: Icons.handyman_rounded,
        count: newMaint,
        title: LocaleKeys.dashboardActionApproveMaintenance.tr(),
        badgeColor: AppColors.error,
        onTap: () => context.push('${Routes.ownerMaintenance}?filter=new'),
      ));
    }

    final overdueTasks = data.tasksBreakdown?.overdue ?? 0;
    if (overdueTasks > 0) {
      items.add(_ActionTile(
        icon: Icons.assignment_late_rounded,
        count: overdueTasks,
        title: LocaleKeys.dashboardActionFollowUpTask.tr(),
        badgeColor: AppColors.warning,
        onTap: () => context.push(Routes.ownerTasks),
      ));
    }

    if (data.expiringContracts > 0) {
      items.add(_ActionTile(
        icon: Icons.autorenew_rounded,
        count: data.expiringContracts,
        title: LocaleKeys.dashboardActionRenewContract.tr(),
        badgeColor: AppColors.warning,
        onTap: () => context.push(Routes.ownerContracts),
      ));
    }

    if (data.overdueInstallmentsCount > 0) {
      items.add(_ActionTile(
        icon: Icons.account_balance_wallet_rounded,
        count: data.overdueInstallmentsCount,
        title: LocaleKeys.dashboardActionCollectOverdue.tr(),
        badgeColor: AppColors.error,
        onTap: () => context.push(Routes.ownerContracts),
      ));
    }

    return items;
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final int count;
  final String title;
  final Color badgeColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.count,
    required this.title,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.primaryColor;
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadius.circularXl,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circularXl,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: context.appSurfaceColor,
            borderRadius: AppRadius.circularXl,
            border: Border.all(color: context.appBorderColor),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Icon(icon, color: primary, size: 19),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: context.appOnSurfaceColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: AppRadius.circularFull,
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: context.appSecondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
