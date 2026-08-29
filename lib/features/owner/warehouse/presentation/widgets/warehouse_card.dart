import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/app_status_badge.dart';
import '../../../../../core/utils/translations/locale_keys.g.dart';
import '../../../../../core/presentation/widgets/custom_action_button.dart';
import '../../domain/entities/warehouse_entity.dart';

class WarehouseCard extends StatelessWidget {
  final WarehouseEntity warehouse;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const WarehouseCard({
    super.key,
    required this.warehouse,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: warehouse.isActive 
              ? context.primaryColor.withValues(alpha: 0.3) 
              : context.appBorderColor,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.store_rounded, color: context.primaryColor, size: 22),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            warehouse.name,
                            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            warehouse.code,
                            style: AppTextStyles.bodySmall.copyWith(color: context.appSecondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppStatusBadge(
                          color: warehouse.isActive ? AppColors.success : AppColors.error,
                          labelKey: warehouse.statusLabel,
                          translateText: false,
                        ),
                        if (onEdit != null || onDelete != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (onEdit != null)
                                CustomActionButton(
                                  icon: Icons.edit_rounded,
                                  color: context.primaryColor,
                                  onTap: onEdit!,
                                ),
                              if (onEdit != null && onDelete != null)
                                const SizedBox(width: AppSpacing.sm),
                              if (onDelete != null)
                                CustomActionButton(
                                  icon: Icons.delete_rounded,
                                  color: AppColors.error,
                                  onTap: onDelete!,
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                if (warehouse.isMain) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: context.primaryColor.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, size: 16, color: context.primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          LocaleKeys.warehouse_is_main_warehouse.tr(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: context.primaryColor, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: context.appBackgroundColor,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn(
                        context,
                        icon: Icons.category_rounded,
                        label: LocaleKeys.warehouse_warehouse_items_count.tr(),
                        value: warehouse.itemsCount.toString(),
                      ),
                      Container(width: 1, height: 40, color: context.appBorderColor),
                      _buildStatColumn(
                        context,
                        icon: Icons.swap_horiz_rounded,
                        label: LocaleKeys.warehouse_warehouse_movements_count.tr(),
                        value: warehouse.movementsCount.toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: context.appSecondaryTextColor),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: context.appSecondaryTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: context.appOnSurfaceColor,
          ),
        ),
      ],
    );
  }
}
