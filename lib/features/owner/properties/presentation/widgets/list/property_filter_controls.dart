import 'package:flutter/material.dart';
import '../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';

class PropertyFilterOption<T> {
  final T value;
  final String label;

  const PropertyFilterOption(this.value, this.label);
}

class PropertyFilterChoiceGroup<T> extends StatelessWidget {
  final String title;
  final List<PropertyFilterOption<T>> options;
  final T? selected;
  final ValueChanged<T?> onChanged;

  const PropertyFilterChoiceGroup({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: options.map((option) {
            final isSelected = option.value == selected;
            return InkWell(
              onTap: () => onChanged(option.value),
              borderRadius: AppRadius.circularLg,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? context.primaryColor
                          : AppColors.surfaceLight,
                  borderRadius: AppRadius.circularLg,
                  border: Border.all(
                    color:
                        isSelected
                            ? context.primaryColor
                            : AppColors.borderLight,
                    width: 1,
                  ),
                  boxShadow:
                      isSelected
                          ? [
                              BoxShadow(
                                color: context.primaryShadow,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                ),
                child: Text(
                  option.label,
                  style: TextStyle(
                    color:
                        isSelected
                            ? Colors.white
                            : AppColors.textSecondaryLight,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class PropertyFilterDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<PropertyFilterOption<T>> options;
  final ValueChanged<T?> onChanged;

  const PropertyFilterDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedOption = options.cast<PropertyFilterOption<T>?>().firstWhere(
      (opt) => opt?.value == value,
      orElse: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        CustomDropdownMenu<PropertyFilterOption<T>>(
          items: options,
          value: selectedOption,
          hint: label,
          itemLabelBuilder: (opt) => opt.label,
          onSelected: (opt) => onChanged(opt.value),
        ),
      ],
    );
  }
}
