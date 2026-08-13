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
import 'owner_occupancy_metric.dart';

class OwnerOccupancyCard extends StatelessWidget {
  final OwnerDashboardEntity data;

  const OwnerOccupancyCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final rate = (data.occupancyRate.toDouble() / 100).clamp(0.0, 1.0);
    final color = data.occupancyRate >= 70
        ? AppColors.success
        : data.occupancyRate >= 40
        ? AppColors.warning
        : AppColors.error;
    return AppSurfaceCard(
      onTap: () => context.push(Routes.ownerOccupancyReport),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pie_chart_outline_rounded,
                size: 18,
                color: context.appSecondaryTextColor,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  LocaleKeys.dashboardOccupancyEfficiency.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.appOnSurfaceColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${data.occupancyRate}%',
                style: AppTextStyles.labelLarge.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: rate),
            duration: const Duration(milliseconds: 900),
            builder: (_, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: context.appBorderColor,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              OwnerOccupancyMetric(
                label: LocaleKeys.ownerPillRented.tr(),
                count: data.rentedUnits,
                color: AppColors.success,
                icon: Icons.check_circle_rounded,
              ),
              const SizedBox(width: AppSpacing.xs),
              OwnerOccupancyMetric(
                label: LocaleKeys.ownerPillVacant.tr(),
                count: data.vacantUnits,
                color: context.appSecondaryTextColor,
                icon: Icons.roofing_rounded,
              ),
              const SizedBox(width: AppSpacing.xs),
              OwnerOccupancyMetric(
                label: LocaleKeys.ownerPillProperties.tr(),
                count: data.totalProperties,
                color: AppColors.accent,
                icon: Icons.domain_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
