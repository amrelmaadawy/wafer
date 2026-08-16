import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: options.map((option) {
          final isSelected = selectedValue == option.value;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
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
                        color: isSelected ? Colors.white : context.appSecondaryTextColor,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      option.labelKey.tr(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : context.appSecondaryTextColor,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    color: isSelected ? primaryColor : AppColors.borderLight.withValues(alpha: 0.6),
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
