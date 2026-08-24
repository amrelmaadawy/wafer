import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../domain/entities/warehouse_item_entity.dart';

class LowStockItemCard extends StatelessWidget {
  final WarehouseItemEntity item;

  const LowStockItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppSurfaceCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: context.appOnSurfaceColor,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.sku != null && item.sku!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${LocaleKeys.warehouse_sku.tr()}: ${item.sku}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.appSubtleSurfaceColor,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    item.category,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textLight,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _buildInfoColumn(
                    label: LocaleKeys.warehouse_quantity_available.tr(),
                    value: item.quantityAvailable.toString(),
                    valueColor: AppColors.error,
                  ),
                ),
                Expanded(
                  child: _buildInfoColumn(
                    label: LocaleKeys.warehouse_min_quantity.tr(),
                    value: item.quantityMinLimit.toString(),
                    valueColor: context.appOnSurfaceColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textLight,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: valueColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
