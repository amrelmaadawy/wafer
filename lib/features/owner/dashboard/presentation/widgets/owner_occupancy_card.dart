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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Icon(Icons.pie_chart_rounded, size: 16, color: color),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  LocaleKeys.dashboardOccupancyEfficiency.tr(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: context.appOnSurfaceColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.circularFull,
                ),
                child: Text(
                  '${data.occupancyRate}%',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: rate),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
            builder: (_, value, _) => ClipRRect(
              borderRadius: AppRadius.circularFull,
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: color.withValues(alpha: 0.12),
                color: color,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _OccupancyChip(
                  label: LocaleKeys.ownerPillRented.tr(),
                  count: data.rentedUnits,
                  color: AppColors.success,
                  icon: Icons.check_circle_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _OccupancyChip(
                  label: LocaleKeys.ownerPillVacant.tr(),
                  count: data.vacantUnits,
                  color: AppColors.warning,
                  icon: Icons.roofing_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _OccupancyChip(
                  label: LocaleKeys.ownerPillProperties.tr(),
                  count: data.totalProperties,
                  color: AppColors.accent,
                  icon: Icons.domain_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OccupancyChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _OccupancyChip({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xs,
        horizontal: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.circularMd,
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 3),
          Text(
            '$count',
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall.copyWith(
              color: context.appSecondaryTextColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
