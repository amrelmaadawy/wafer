import 'package:flutter/material.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import 'owner_navigation_destination.dart';

class OwnerNavigationRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const OwnerNavigationRail({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final destinations = ownerNavigationDestinations();
    return Container(
      width: AppSizes.imageAvatarLg + AppSizes.iconSm,
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        border: BorderDirectional(
          end: BorderSide(color: context.appBorderColor),
        ),
      ),
      child: SafeArea(
        child: NavigationRail(
          backgroundColor: Colors.transparent,
          selectedIndex: currentIndex,
          onDestinationSelected: onTabChanged,
          labelType: NavigationRailLabelType.all,
          indicatorColor: context.primaryColor.withValues(alpha: 0.12),
          selectedIconTheme: IconThemeData(color: context.primaryColor),
          selectedLabelTextStyle: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: context.primaryColor),
          destinations: destinations
              .map(
                (item) => NavigationRailDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: Text(item.label),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}
