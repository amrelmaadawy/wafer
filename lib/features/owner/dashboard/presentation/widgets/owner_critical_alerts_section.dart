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
import '../../domain/entities/owner_dashboard_entity.dart';

class OwnerCriticalAlertsSection extends StatelessWidget {
  final OwnerDashboardEntity data;

  const OwnerCriticalAlertsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final alerts = _buildAlerts(context);

    if (alerts.isEmpty) return _buildAllClearCard(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(
          icon: Icons.warning_amber_rounded,
          color: AppColors.error,
          label: LocaleKeys.dashboardCriticalAlertsTitle.tr(),
          trailing: Text(
            LocaleKeys.dashboardCriticalAlertsSub.tr(),
            style: AppTextStyles.labelSmall
                .copyWith(color: context.appSecondaryTextColor),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (var i = 0; i < alerts.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.xs),
          alerts[i],
        ],
      ],
    );
  }

  List<Widget> _buildAlerts(BuildContext context) {
    final list = <Widget>[];

    if (data.overdueInstallmentsCount > 0) {
      list.add(_CriticalAlertTile(
        icon: Icons.payments_rounded,
        color: AppColors.error,
        message: LocaleKeys.dashboardAlertOverdueInstallments
            .tr(args: [data.overdueInstallmentsCount.toString()]),
        actionLabel: LocaleKeys.dashboardActionViewDetails.tr(),
        onTap: () => context.push(Routes.ownerContracts),
        isUrgent: true,
      ));
    }

    if (data.expiringContracts > 0) {
      list.add(_CriticalAlertTile(
        icon: Icons.history_toggle_off_rounded,
        color: AppColors.warning,
        message: LocaleKeys.dashboardAlertExpiringContracts
            .tr(args: [data.expiringContracts.toString()]),
        actionLabel: LocaleKeys.dashboardActionViewDetails.tr(),
        onTap: () => context.push(Routes.ownerContracts),
      ));
    }

    final urgentMaint = data.maintenanceBreakdown?.urgent ?? 0;
    final totalPendingMaint = data.pendingMaintenance;
    if (urgentMaint > 0 || totalPendingMaint > 0) {
      final isUrgent = urgentMaint > 0;
      list.add(_CriticalAlertTile(
        icon: Icons.build_circle_rounded,
        color: isUrgent ? AppColors.error : AppColors.warning,
        message: LocaleKeys.dashboardAlertPendingMaintenance.tr(
          args: [(isUrgent ? urgentMaint : totalPendingMaint).toString()],
        ),
        actionLabel: LocaleKeys.dashboardActionViewDetails.tr(),
        onTap: () => context.push('${Routes.ownerMaintenance}?filter=new'),
        isUrgent: isUrgent,
      ));
    }

    final openCases = data.legalCasesBreakdown?.openCases ?? 0;
    if (openCases > 0) {
      list.add(_CriticalAlertTile(
        icon: Icons.gavel_rounded,
        color: AppColors.warning,
        message: LocaleKeys.dashboardAlertOpenLegalCases
            .tr(args: [openCases.toString()]),
        actionLabel: LocaleKeys.dashboardActionViewDetails.tr(),
        onTap: () => context.push(Routes.ownerLegalCases),
      ));
    }

    return list;
  }

  Widget _buildAllClearCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.06),
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.dashboardAllClear.tr(),
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  LocaleKeys.dashboardAllClearSub.tr(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.success.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final Widget? trailing;

  const _SectionLabel({
    required this.icon,
    required this.color,
    required this.label,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: context.appOnSurfaceColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (trailing != null) ...[const Spacer(), trailing!],
      ],
    );
  }
}

class _CriticalAlertTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;
  final String actionLabel;
  final VoidCallback onTap;
  final bool isUrgent;

  const _CriticalAlertTile({
    required this.icon,
    required this.color,
    required this.message,
    required this.actionLabel,
    required this.onTap,
    this.isUrgent = false,
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
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.appSurfaceColor,
            borderRadius: AppRadius.circularXl,
            border: Border.all(color: context.appBorderColor),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: isUrgent ? 0.08 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 3.5, color: color),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: AppRadius.circularMd,
                          ),
                          child: Icon(icon, color: color, size: 18),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            message,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: context.appOnSurfaceColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: AppRadius.circularFull,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                actionLabel,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(Icons.arrow_forward_ios_rounded, color: color, size: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
