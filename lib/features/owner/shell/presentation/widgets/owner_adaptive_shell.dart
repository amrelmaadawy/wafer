import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/offline_banner.dart';
import '../../../../../core/theme/app_breakpoints.dart';
import 'owner_bottom_nav_widget.dart';
import 'owner_navigation_rail.dart';

class OwnerAdaptiveShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const OwnerAdaptiveShell({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final wrappedChild = OfflineBannerWidget(child: child);

    if (context.isCompact) {
      return Scaffold(
        extendBody: true,
        body: wrappedChild,
        bottomNavigationBar: OwnerBottomNavWidget(
          currentIndex: currentIndex,
          onTabChanged: onTabChanged,
        ),
      );
    }
    return Scaffold(
      body: Row(
        children: [
          OwnerNavigationRail(
            currentIndex: currentIndex,
            onTabChanged: onTabChanged,
          ),
          Expanded(child: wrappedChild),
        ],
      ),
    );
  }
}
