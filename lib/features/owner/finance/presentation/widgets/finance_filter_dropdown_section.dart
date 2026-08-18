import 'package:flutter/material.dart';
import '../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_context.dart';

class FinanceFilterDropdownSection extends StatelessWidget {
  final String title;
  final bool isLoading;
  final List<String> items;
  final String? selectedValue;
  final String hint;
  final ValueChanged<String?> onSelected;

  const FinanceFilterDropdownSection({
    super.key,
    required this.title,
    required this.isLoading,
    required this.items,
    required this.selectedValue,
    required this.hint,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: context.appOnSurfaceColor,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (isLoading)
          const LinearProgressIndicator(minHeight: 2)
        else
          CustomDropdownMenu<String>(
            items: items,
            value: items.contains(selectedValue) ? selectedValue : null,
            hint: hint,
            itemLabelBuilder: (item) => item,
            onSelected: onSelected,
          ),
      ],
    );
  }
}
