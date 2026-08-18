import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/color_utils.dart';
import '../../../theme/theme_context.dart';

class SortDirectionButton extends StatelessWidget {
  final String titleKey;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SortDirectionButton({
    super.key,
    required this.titleKey,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circularLg,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.1)
              : context.appSurfaceColor,
          borderRadius: AppRadius.circularLg,
          border: Border.all(
            color: isSelected
                ? primaryColor
                : AppColors.borderLight.withValues(alpha: 0.8),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? primaryColor : context.appSecondaryTextColor,
            ),
            const SizedBox(width: 6),
            Text(
              titleKey.tr(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? primaryColor : context.appOnSurfaceColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
