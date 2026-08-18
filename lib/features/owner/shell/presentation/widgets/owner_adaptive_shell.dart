import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/offline_banner.dart';
import '../../../../../core/theme/app_breakpoints.dart';
import 'owner_drawer_widget.dart';

class OwnerAdaptiveShell extends StatefulWidget {
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
  State<OwnerAdaptiveShell> createState() => _OwnerAdaptiveShellState();
}

class _OwnerAdaptiveShellState extends State<OwnerAdaptiveShell> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final wrappedChild = OfflineBannerWidget(child: widget.child);

    if (context.isCompact) {
      return Scaffold(
        drawer: OwnerDrawerWidget(
          currentBranchIndex: widget.currentIndex,
          onSelectBranch: widget.onTabChanged,
        ),
        body: wrappedChild,
      );
    }

    return Scaffold(
      body: Row(
        children: [
          OwnerDrawerWidget(
            currentBranchIndex: widget.currentIndex,
            onSelectBranch: widget.onTabChanged,
            isCollapsed: _isCollapsed,
            onToggleCollapse: () {
              setState(() {
                _isCollapsed = !_isCollapsed;
              });
            },
          ),
          Expanded(child: wrappedChild),
        ],
      ),
    );
  }
}
