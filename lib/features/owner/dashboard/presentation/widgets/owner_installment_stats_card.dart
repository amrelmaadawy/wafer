import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_radius.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: AppRadius.circularSm,
                    ),
                    child: const Icon(Icons.pie_chart_rounded, color: AppColors.info, size: 16),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    LocaleKeys.dashboard_installment_stats.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: context.appOnSurfaceColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Icon(Icons.chevron_right_rounded, color: context.appSecondaryTextColor.withValues(alpha: 0.5), size: 18),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildProgressBar(context, stats),
          const SizedBox(height: AppSpacing.sm),
          Column(
            children: [
              Row(
                children: [
                  OwnerInstallmentStatItem(
                    label: LocaleKeys.dashboard_paid.tr(),
                    count: stats.paid,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  OwnerInstallmentStatItem(
                    label: LocaleKeys.dashboard_partially_paid.tr(),
                    count: stats.partiallyPaid,
                    color: AppColors.warning,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  OwnerInstallmentStatItem(
                    label: LocaleKeys.dashboard_unpaid.tr(),
                    count: stats.unpaid,
                    color: context.appSecondaryTextColor,
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
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, InstallmentStatsEntity stats) {
    final total = stats.paid + stats.unpaid + stats.partiallyPaid + stats.overdue;
    if (total == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.ownerTotal.tr(),
              style: AppTextStyles.labelSmall.copyWith(
                color: context.appSecondaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$total',
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.appOnSurfaceColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: AppRadius.circularLg,
          child: SizedBox(
            height: 7,
            width: double.infinity,
            child: Row(
              children: [
                if (stats.paid > 0)
                  Expanded(flex: stats.paid, child: Container(color: AppColors.success)),
                if (stats.partiallyPaid > 0)
                  Expanded(flex: stats.partiallyPaid, child: Container(color: AppColors.warning)),
                if (stats.overdue > 0)
                  Expanded(flex: stats.overdue, child: Container(color: AppColors.error)),
                if (stats.unpaid > 0)
                  Expanded(
                    flex: stats.unpaid,
                    child: Container(color: context.appSecondaryTextColor.withValues(alpha: 0.15)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
