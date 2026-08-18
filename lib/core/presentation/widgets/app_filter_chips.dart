import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../theme/app_fonts.dart';
import '../../theme/app_spacing.dart';
import '../../theme/color_utils.dart';
import '../../theme/theme_context.dart';

class AppFilterOption<T> {
  final T value;
  final String labelKey;
  final IconData? icon;

  const AppFilterOption({
    required this.value,
    required this.labelKey,
    this.icon,
  });
}

/// A horizontal scrollable list of filter chips.
class AppFilterChips<T> extends StatelessWidget {
  final List<AppFilterOption<T>> options;
  final T? selectedValue;
  final ValueChanged<T?> onSelected;

  const AppFilterChips({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = selectedValue == option.value;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (option.icon != null) ...[
                      Icon(
                        option.icon,
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : context.appSecondaryTextColor,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      option.labelKey.tr(),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? Colors.white
                            : context.appSecondaryTextColor,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                labelPadding: EdgeInsets.zero,
                elevation: 0,
                pressElevation: 0,
                onSelected: (selected) {
                  if (selected) {
                    onSelected(option.value);
                  } else {
                    onSelected(null);
                  }
                },
                selectedColor: primaryColor,
                backgroundColor: context.appSurfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: isSelected
                        ? primaryColor
                        : context.appBorderColor.withValues(alpha: 0.8),
                    width: isSelected ? 0 : 1,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
