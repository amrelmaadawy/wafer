import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';

class LabeledDropdownWidget<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final void Function(T) onSelected;

  const LabeledDropdownWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = items.isEmpty;
    final String displayHint = isEmpty
        ? LocaleKeys.no_data_available.tr()
        : hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        CustomDropdownMenu<T>(
          items: items,
          value: value,
          hint: displayHint,
          itemLabelBuilder: itemLabelBuilder,
          onSelected: isEmpty ? null : onSelected,
        ),
      ],
    );
  }
}
