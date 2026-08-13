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
import '../../domain/entities/owner_dashboard_entity.dart';
import 'owner_financial_metric.dart';

class OwnerFinancialSummaryCard extends StatelessWidget {
  final OwnerDashboardEntity data;

  const OwnerFinancialSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.ownerRevenueReport),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.primaryDark,
              context.primaryColor,
              context.primaryLight,
            ],
          ),
          borderRadius: AppRadius.circularXxl,
          boxShadow: [
            BoxShadow(
              color: context.primaryShadow,
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white70,
                  size: 17,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    LocaleKeys.dashboardFinancialPosition.tr(),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
                if (data.overdueInstallmentsCount > 0)
                  _OverdueBadge(count: data.overdueInstallmentsCount),
              ],
            ),
            Text(
              _currency(data.pendingAmount),
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
            Text(
              LocaleKeys.dashboardTotalDuePending.tr(),
              style: AppTextStyles.labelSmall.copyWith(color: Colors.white60),
            ),
            Divider(color: Colors.white.withValues(alpha: 0.15)),
            Row(
              children: [
                OwnerFinancialMetric(
                  label: LocaleKeys.ownerCollected.tr(),
                  amount: data.collectedAmount,
                  color: AppColors.success,
                  icon: Icons.check_circle_outline_rounded,
                ),
                OwnerFinancialMetric(
                  label: LocaleKeys.ownerPending.tr(),
                  amount: data.pendingAmount,
                  color: AppColors.warning,
                  icon: Icons.pending_actions_rounded,
                ),
                OwnerFinancialMetric(
                  label: LocaleKeys.ownerTotal.tr(),
                  amount: data.totalRevenue,
                  color: Colors.white,
                  icon: Icons.bar_chart_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _currency(num value) => LocaleKeys.commonCurrencySar.tr(
    args: [value.toStringAsFixed(value == value.toInt() ? 0 : 2)],
  );
}

class _OverdueBadge extends StatelessWidget {
  final int count;

  const _OverdueBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count ${LocaleKeys.dashboardOverdue.tr()}',
      style: AppTextStyles.labelSmall.copyWith(
        color: AppColors.error,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
