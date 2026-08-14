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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.primaryDark,
              context.primaryColor,
              context.primaryLight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
        child: Stack(
          children: [
            // Watermark Icon
            PositionedDirectional(
              end: -20,
              bottom: -20,
              child: Icon(
                Icons.account_balance_wallet_rounded,
                size: 160,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          LocaleKeys.dashboardFinancialPosition.tr(),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (data.overdueInstallmentsCount > 0)
                        _OverdueBadge(count: data.overdueInstallmentsCount),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currency(data.pendingAmount),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        LocaleKeys.dashboardTotalDuePending.tr(),
                        style: AppTextStyles.labelSmall
                            .copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Divider(color: Colors.white.withValues(alpha: 0.15), height: 1),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OwnerFinancialMetric(
                        label: LocaleKeys.ownerCollected.tr(),
                        amount: data.collectedAmount,
                        color: Colors.greenAccent,
                        icon: Icons.check_circle_rounded,
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
                        icon: Icons.analytics_rounded,
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

  String _currency(num value) => LocaleKeys.commonCurrencySar.tr(
        args: [value.toStringAsFixed(value == value.toInt() ? 0 : 2)],
      );
}

class _OverdueBadge extends StatelessWidget {
  final int count;

  const _OverdueBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_rounded,
              color: Colors.redAccent, size: 14),
          const SizedBox(width: 4),
          Text(
            '$count ${LocaleKeys.dashboardOverdue.tr()}',
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.redAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
