import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../domain/entities/warehouse_stats_entity.dart';

class WarehouseStatsGrid extends StatelessWidget {
  final WarehouseStatsEntity stats;

  const WarehouseStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                title: LocaleKeys.warehouse_stats_inventory_value.tr(),
                value: stats.inventoryValue.toStringAsFixed(2),
                icon: Icons.account_balance_wallet_outlined,
                color: AppColors.success,
                isCurrency: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                title: LocaleKeys.warehouse_stats_total_items.tr(),
                value: stats.totalItems.toString(),
                icon: Icons.inventory_2_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                context,
                title: LocaleKeys.warehouse_stats_low_items.tr(),
                value: stats.lowItems.toString(),
                icon: Icons.warning_amber_rounded,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                title: LocaleKeys.warehouse_stats_active_items.tr(),
                value: stats.activeItems.toString(),
                icon: Icons.check_circle_outline,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                context,
                title: LocaleKeys.warehouse_stats_out_items.tr(),
                value: stats.outItems.toString(),
                icon: Icons.cancel_outlined,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isCurrency = false,
  }) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.h2.copyWith(
                  fontSize: 20,
                  color: context.appOnSurfaceColor,
                ),
              ),
              if (isCurrency) ...[
                const SizedBox(width: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    LocaleKeys.warehouse_currency.tr(),
                    style: AppTextStyles.labelMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
