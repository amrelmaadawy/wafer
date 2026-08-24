import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/presentation/widgets/custom_cached_image.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/warehouse_item_entity.dart';

class WarehouseItemListCard extends StatelessWidget {
  final WarehouseItemEntity item;

  const WarehouseItemListCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('${Routes.ownerWarehouseItemDetails}/${item.id}');
      },
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: AppSurfaceCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              if (item.imageUrl != null)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: context.appBorderColor),
                  ),
                  child: CustomCachedImage(
                    imageUrl: item.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: context.appSubtleSurfaceColor,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: context.appBorderColor),
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.textLight,
                    size: 24,
                  ),
                ),
              const SizedBox(width: AppSpacing.md),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: context.appOnSurfaceColor,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.category,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (item.sku != null && item.sku!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${LocaleKeys.warehouse_sku.tr()}: ${item.sku}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(item.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  item.statusLabel,
                  style: TextStyle(
                    color: _getStatusColor(item.status),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Quantities and Price
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.appSubtleSurfaceColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(
                  context,
                  label: LocaleKeys.warehouse_quantity_available.tr(),
                  value: item.quantityAvailable.toString(),
                  valueColor: item.quantityAvailable <= item.quantityMinLimit
                      ? AppColors.error
                      : context.appOnSurfaceColor,
                ),
                Container(width: 1, height: 24, color: context.appBorderColor),
                _buildInfoColumn(
                  context,
                  label: LocaleKeys.warehouse_cost.tr(), // Using translation key available
                  value: '${item.finalSellingPrice} ${LocaleKeys.warehouse_currency.tr()}',
                  valueColor: context.appOnSurfaceColor,
                ),
                Container(width: 1, height: 24, color: context.appBorderColor),
                _buildInfoColumn(
                  context,
                  label: LocaleKeys.status.tr(),
                  value: item.warehouse.name,
                  valueColor: context.appOnSurfaceColor,
                  isFlexible: true,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildInfoColumn(
    BuildContext context, {
    required String label,
    required String value,
    required Color valueColor,
    bool isFlexible = false,
  }) {
    final column = Column(
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    if (isFlexible) {
      return Expanded(child: column);
    }
    return column;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'low':
      case 'low_stock':
        return AppColors.warning;
      case 'out':
      case 'out_of_stock':
        return AppColors.error;
      default:
        return AppColors.textLight;
    }
  }
}
