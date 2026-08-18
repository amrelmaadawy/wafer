import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../models/drawer_navigation_item.dart';

class OwnerDrawerItemWidget extends StatelessWidget {
  final DrawerNavItem item;
  final bool isSelected;
  final bool isSubItem;
  final bool isCollapsed;
  final VoidCallback onTap;

  const OwnerDrawerItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    this.isSubItem = false,
    this.isCollapsed = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.primaryColor;

    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Tooltip(
          message: item.labelKey.tr(),
          preferBelow: false,
          child: Material(
            color: isSelected
                ? primary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: AppRadius.circularMd,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                onTap();
              },
              borderRadius: AppRadius.circularMd,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.circularMd,
                  border: isSelected
                      ? Border.all(color: primary.withValues(alpha: 0.3))
                      : null,
                ),
                child: Center(
                  child: Icon(
                    isSelected ? item.effectiveActiveIcon : item.icon,
                    size: 22,
                    color: isSelected
                        ? primary
                        : context.appSecondaryTextColor.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSubItem ? AppSpacing.xs : 2,
        vertical: 0,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.circularMd,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: AppRadius.circularMd,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isSubItem ? AppSpacing.md : AppSpacing.sm,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? primary.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? item.effectiveActiveIcon : item.icon,
                    size: isSubItem ? 18 : 20,
                    color: isSelected
                        ? primary
                        : context.appSecondaryTextColor.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      item.labelKey.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? primary
                            : context.appOnSurfaceColor.withValues(alpha: 0.9),
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: isSubItem ? 13.0 : 13.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (item.badgeCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? primary : AppColors.error,
                      borderRadius: AppRadius.circularFull,
                    ),
                    child: Text(
                      '${item.badgeCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
