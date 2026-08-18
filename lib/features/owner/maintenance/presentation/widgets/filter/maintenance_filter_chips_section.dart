import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';

class MaintenanceFilterChipsOption {
  final String key;
  final String labelKey;

  const MaintenanceFilterChipsOption({
    required this.key,
    required this.labelKey,
  });
}

class MaintenanceFilterChipsSection extends StatelessWidget {
  final String titleKey;
  final List<MaintenanceFilterChipsOption> options;
  final String? selectedValue;
  final ValueChanged<String?> onSelected;

  const MaintenanceFilterChipsSection({
    super.key,
    required this.titleKey,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleKey.tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: context.appOnSurfaceColor,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected = selectedValue == opt.key;
            return ChoiceChip(
              label: Text(opt.labelKey.tr()),
              selected: isSelected,
              selectedColor: primaryColor,
              backgroundColor: context.appSurfaceColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : context.appOnSurfaceColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.circularFull,
                side: BorderSide(
                  color: isSelected ? primaryColor : AppColors.borderLight,
                ),
              ),
              onSelected: (selected) {
                onSelected(selected ? opt.key : null);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
