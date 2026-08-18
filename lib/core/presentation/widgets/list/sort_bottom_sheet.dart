import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../localization/locale_keys.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/color_utils.dart';
import '../../../theme/theme_context.dart';
import 'sort_direction_button.dart';
import 'sort_radio_indicator.dart';
import 'unified_bottom_sheet.dart';

class AppSortOption<T> {
  final T field;
  final String labelLocaleKey;
  final IconData? icon;

  const AppSortOption({
    required this.field,
    required this.labelLocaleKey,
    this.icon,
  });
}

/// A standardized modal bottom sheet for sorting list data.
class SortBottomSheet<T> extends StatefulWidget {
  final List<AppSortOption<T>> options;
  final T? initialField;
  final bool initialAscending;
  final void Function(T? field, bool isAscending) onApply;
  final VoidCallback onReset;

  const SortBottomSheet({
    super.key,
    required this.options,
    required this.initialField,
    required this.initialAscending,
    required this.onApply,
    required this.onReset,
  });

  static Future<void> show<T>({
    required BuildContext context,
    required List<AppSortOption<T>> options,
    required T? initialField,
    required bool initialAscending,
    required void Function(T? field, bool isAscending) onApply,
    required VoidCallback onReset,
  }) {
    return UnifiedBottomSheet.show(
      context: context,
      builder: (_) => SortBottomSheet<T>(
        options: options,
        initialField: initialField,
        initialAscending: initialAscending,
        onApply: onApply,
        onReset: onReset,
      ),
    );
  }

  @override
  State<SortBottomSheet<T>> createState() => _SortBottomSheetState<T>();
}

class _SortBottomSheetState<T> extends State<SortBottomSheet<T>> {
  late T? _selectedField;
  late bool _isAscending;

  @override
  void initState() {
    super.initState();
    _selectedField = widget.initialField;
    _isAscending = widget.initialAscending;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return UnifiedBottomSheet(
      titleLocaleKey: LocaleKeys.sortOptionsTitle,
      titleIcon: Icons.swap_vert_rounded,
      onReset: () {
        setState(() {
          _selectedField = null;
          _isAscending = true;
        });
        widget.onReset();
      },
      onApply: () => widget.onApply(_selectedField, _isAscending),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.sortByLabel.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: context.appOnSurfaceColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...widget.options.map((option) {
            final isSelected = _selectedField == option.field;
            return InkWell(
              onTap: () => setState(() => _selectedField = option.field),
              borderRadius: AppRadius.circularLg,
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: AppRadius.circularLg,
                  border: Border.all(
                    color: isSelected
                        ? primaryColor.withValues(alpha: 0.4)
                        : AppColors.borderLight.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    if (option.icon != null) ...[
                      Icon(
                        option.icon,
                        size: 18,
                        color: isSelected
                            ? primaryColor
                            : context.appSecondaryTextColor,
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Text(
                        option.labelLocaleKey.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? primaryColor
                              : context.appOnSurfaceColor,
                        ),
                      ),
                    ),
                    SortRadioIndicator(
                      isSelected: isSelected,
                      primaryColor: primaryColor,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),
          Text(
            LocaleKeys.sortDirection.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: context.appOnSurfaceColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: SortDirectionButton(
                  titleKey: LocaleKeys.sortAscending,
                  icon: Icons.arrow_upward_rounded,
                  isSelected: _isAscending,
                  onTap: () => setState(() => _isAscending = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SortDirectionButton(
                  titleKey: LocaleKeys.sortDescending,
                  icon: Icons.arrow_downward_rounded,
                  isSelected: !_isAscending,
                  onTap: () => setState(() => _isAscending = false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
