import 'package:flutter/material.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/color_utils.dart';
import '../../../theme/theme_context.dart';
import '../app_filter_chips.dart';

/// A standardized header bar placing Sort, Filter, and quick filter chips horizontally.
class FilterSortHeaderBar<T> extends StatelessWidget {
  final Widget? searchField;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSortTap;
  final int activeFiltersCount;
  final bool isSortActive;
  final List<AppFilterOption<T>>? quickFilterOptions;
  final T? selectedQuickFilter;
  final ValueChanged<T?>? onQuickFilterSelected;
  final EdgeInsetsGeometry? padding;

  const FilterSortHeaderBar({
    super.key,
    this.searchField,
    this.onFilterTap,
    this.onSortTap,
    this.activeFiltersCount = 0,
    this.isSortActive = false,
    this.quickFilterOptions,
    this.selectedQuickFilter,
    this.onQuickFilterSelected,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchField != null || onFilterTap != null || onSortTap != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (searchField != null) Expanded(child: searchField!),
                  if (searchField == null) const Spacer(),
                  if (onSortTap != null) ...[
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.swap_vert_rounded,
                      onTap: onSortTap!,
                      hasBadge: isSortActive,
                    ),
                  ],
                  if (onFilterTap != null) ...[
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.tune_rounded,
                      onTap: onFilterTap!,
                      hasBadge: activeFiltersCount > 0,
                      badgeText: activeFiltersCount > 0
                          ? '$activeFiltersCount'
                          : null,
                    ),
                  ],
                ],
              ),
            ),
          if (quickFilterOptions != null && quickFilterOptions!.isNotEmpty) ...[
            if (searchField != null || onFilterTap != null || onSortTap != null)
              const SizedBox(height: 12),
            AppFilterChips<T>(
              options: quickFilterOptions!,
              selectedValue: selectedQuickFilter,
              onSelected: onQuickFilterSelected ?? (_) {},
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;
  final String? badgeText;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.hasBadge,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circularXl,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: hasBadge
                ? primaryColor.withValues(alpha: 0.1)
                : context.appSurfaceColor,
            borderRadius: AppRadius.circularXl,
            border: Border.all(
              color: hasBadge
                  ? primaryColor.withValues(alpha: 0.4)
                  : context.appBorderColor.withValues(alpha: 0.6),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: hasBadge ? primaryColor : context.appSecondaryTextColor,
              ),
              if (hasBadge)
                Positioned(
                  top: 6,
                  right: 6,
                  child: badgeText != null
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badgeText!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
