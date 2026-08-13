import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/owner_dashboard_entity.dart';
import 'owner_installment_stat_item.dart';

class OwnerInstallmentStatsCard extends StatelessWidget {
  final InstallmentStatsEntity stats;

  const OwnerInstallmentStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      onTap: () => context.push(Routes.ownerDefaultersReport),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.pie_chart_outline,
                color: AppColors.info,
                size: 19,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                LocaleKeys.dashboard_installment_stats.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.appOnSurfaceColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              OwnerInstallmentStatItem(
                label: LocaleKeys.dashboard_paid.tr(),
                count: stats.paid,
                color: AppColors.success,
              ),
              const SizedBox(width: AppSpacing.sm),
              OwnerInstallmentStatItem(
                label: LocaleKeys.dashboard_unpaid.tr(),
                count: stats.unpaid,
                color: context.appSecondaryTextColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              OwnerInstallmentStatItem(
                label: LocaleKeys.dashboard_partially_paid.tr(),
                count: stats.partiallyPaid,
                color: AppColors.warning,
              ),
              const SizedBox(width: AppSpacing.sm),
              OwnerInstallmentStatItem(
                label: LocaleKeys.dashboard_overdue.tr(),
                count: stats.overdue,
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
