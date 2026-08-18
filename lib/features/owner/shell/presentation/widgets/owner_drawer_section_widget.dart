import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../models/drawer_navigation_item.dart';
import 'owner_drawer_item_widget.dart';

class OwnerDrawerSectionWidget extends StatelessWidget {
  final DrawerNavSection section;
  final int currentBranchIndex;
  final bool isExpanded;
  final bool isCollapsed;
  final VoidCallback onToggle;
  final ValueChanged<DrawerNavItem> onItemTap;

  const OwnerDrawerSectionWidget({
    super.key,
    required this.section,
    required this.currentBranchIndex,
    required this.isExpanded,
    this.isCollapsed = false,
    required this.onToggle,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasActiveChild = section.containsBranchIndex(currentBranchIndex);
    final primary = context.primaryColor;

    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: PopupMenuButton<DrawerNavItem>(
          tooltip: section.titleKey.tr(),
          offset: const Offset(50, 0),
          color: context.appSurfaceColor,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
          onSelected: onItemTap,
          itemBuilder: (ctx) => section.items.map((item) {
            final isSelected = item.branchIndex == currentBranchIndex;
            return PopupMenuItem<DrawerNavItem>(
              value: item,
              child: Row(
                children: [
                  Icon(
                    isSelected ? item.effectiveActiveIcon : item.icon,
                    size: 20,
                    color: isSelected ? primary : context.appSecondaryTextColor,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    item.labelKey.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected ? primary : context.appOnSurfaceColor,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: hasActiveChild
                  ? primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: AppRadius.circularMd,
              border: hasActiveChild
                  ? Border.all(color: primary.withValues(alpha: 0.3))
                  : null,
            ),
            child: Center(
              child: Icon(
                section.icon,
                size: 22,
                color: hasActiveChild
                    ? primary
                    : context.appSecondaryTextColor.withValues(alpha: 0.85),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: AppRadius.circularMd,
            child: InkWell(
              onTap: onToggle,
              borderRadius: AppRadius.circularMd,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      section.icon,
                      size: 20,
                      color: hasActiveChild
                          ? primary
                          : context.appSecondaryTextColor.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        section.titleKey.tr(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: hasActiveChild
                              ? primary
                              : context.appOnSurfaceColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more_rounded,
                        size: 18,
                        color: hasActiveChild
                            ? primary
                            : context.appSecondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 1, bottom: 2),
              child: Column(
                children: section.items.map((item) {
                  final isSelected = item.branchIndex == currentBranchIndex;
                  return OwnerDrawerItemWidget(
                    item: item,
                    isSelected: isSelected,
                    isSubItem: true,
                    isCollapsed: false,
                    onTap: () => onItemTap(item),
                  );
                }).toList(growable: false),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
