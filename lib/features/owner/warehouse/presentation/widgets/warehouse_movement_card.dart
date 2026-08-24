import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../domain/entities/warehouse_movement_entity.dart';

class WarehouseMovementCard extends StatelessWidget {
  final WarehouseMovementEntity movement;

  const WarehouseMovementCard({super.key, required this.movement});

  @override
  Widget build(BuildContext context) {
    // Determine icon and colors based on movement type.
    // Assuming 'receive' and 'issue' or similar types.
    final bool isReceive = movement.type == 'receive' || movement.type == 'return' || movement.quantity > 0;
    final Color typeColor = isReceive ? AppColors.success : AppColors.error;
    final IconData typeIcon = isReceive ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppSurfaceCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(typeIcon, size: 16, color: typeColor),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  movement.item.name,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: context.appOnSurfaceColor,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                movement.date.length >= 10 ? movement.date.substring(0, 10) : movement.date,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textLight,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.appSubtleSurfaceColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(
                  context,
                  label: LocaleKeys.warehouse_qty_before.tr(),
                  value: movement.quantityBefore.toString(),
                ),
                Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textLight),
                _buildInfoColumn(
                  context,
                  label: LocaleKeys.warehouse_qty_after.tr(),
                  value: movement.quantityAfter.toString(),
                  valueColor: Theme.of(context).primaryColor,
                ),
                Container(width: 1, height: 24, color: context.appBorderColor),
                _buildInfoColumn(
                  context,
                  label: LocaleKeys.warehouse_cost.tr(),
                  value: '${movement.totalCost} ${LocaleKeys.warehouse_currency.tr()}',
                ),
              ],
            ),
          ),
        ],
      ),
     ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textLight,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: valueColor ?? context.appOnSurfaceColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
