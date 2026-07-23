import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/color_utils.dart';

class CustomDropdownMenu<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String hint;
  final String Function(T) itemLabelBuilder;
  final void Function(T)? onSelected;
  final bool isExpanded;
  final String? errorText;
  final double height;

  const CustomDropdownMenu({
    super.key,
    required this.items,
    required this.value,
    required this.hint,
    required this.itemLabelBuilder,
    this.onSelected,
    this.isExpanded = true,
    this.errorText,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: AppRadius.circularLg,
            border: Border.all(
              color: errorText != null ? Colors.red : const Color(0xFFE2E8F0),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                ),
                child: PopupMenuButton<T>(
                  initialValue: value,
                  color: Colors.white,
                  elevation: 4,
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    maxWidth: constraints.maxWidth,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  position: PopupMenuPosition.under,
                  offset: const Offset(0, 4),
                  onSelected: onSelected,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        value != null ? itemLabelBuilder(value as T) : hint,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: value != null ? FontWeight.w600 : FontWeight.w500,
                          color: value != null ? AppColors.textPrimaryLight : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondaryLight, size: 20),
                  ],
                ),
              ),
              itemBuilder: (context) {
                return items.map((item) {
                  final isSelected = value == item;
                  return PopupMenuItem<T>(
                    value: item,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isSelected ? context.primaryColor.withValues(alpha: 0.08) : Colors.transparent,
                        borderRadius: AppRadius.circularMd,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              itemLabelBuilder(item),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isSelected ? context.primaryColor : AppColors.textPrimaryLight,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle_rounded, color: context.primaryColor, size: 18),
                        ],
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          );
        },
      ),
    ),
    if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
  }
}
