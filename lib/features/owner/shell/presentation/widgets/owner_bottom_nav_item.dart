import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_durations.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import 'owner_navigation_destination.dart';

class OwnerBottomNavItem extends StatelessWidget {
  final OwnerNavigationDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  const OwnerBottomNavItem({
    super.key,
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      button: true,
      label: destination.label,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: AppRadius.circularXxl,
        child: AnimatedContainer(
          duration: AppDurations.medium,
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 16 : 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? context.primaryColor : Colors.transparent,
            borderRadius: AppRadius.circularXxl,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.primaryShadow,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? destination.selectedIcon : destination.icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : context.appSecondaryTextColor,
                size: 22,
              ),
              AnimatedSize(
                duration: AppDurations.fast,
                child: isSelected
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(start: 6),
                        child: Text(
                          destination.label,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
