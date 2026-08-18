import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/theme_context.dart';

class FinanceDatePickerTile extends StatelessWidget {
  final String label;
  final bool hasValue;
  final Color primaryColor;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const FinanceDatePickerTile({
    super.key,
    required this.label,
    required this.hasValue,
    required this.primaryColor,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circularLg,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: context.appSurfaceColor,
          borderRadius: AppRadius.circularLg,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 16, color: primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: hasValue
                      ? context.appOnSurfaceColor
                      : context.appSecondaryTextColor,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasValue)
              GestureDetector(
                onTap: onClear,
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppColors.textSecondaryLight,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
