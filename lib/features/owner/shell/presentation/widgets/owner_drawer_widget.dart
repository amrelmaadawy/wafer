import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wafer/core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../../profile/presentation/cubit/profile_state.dart';
import '../models/drawer_navigation_item.dart';
import 'owner_drawer_footer.dart';
import 'owner_drawer_header.dart';
import 'owner_drawer_item_widget.dart';
import 'owner_drawer_section_widget.dart';

class OwnerDrawerWidget extends StatefulWidget {
  final int currentBranchIndex;
  final ValueChanged<int> onSelectBranch;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  const OwnerDrawerWidget({
    super.key,
    required this.currentBranchIndex,
    required this.onSelectBranch,
    this.isCollapsed = false,
    this.onToggleCollapse,
  });

  @override
  State<OwnerDrawerWidget> createState() => _OwnerDrawerWidgetState();
}

class _OwnerDrawerWidgetState extends State<OwnerDrawerWidget> {
  final Set<String> _expandedSectionKeys = {};

  @override
  void initState() {
    super.initState();
    _autoExpandActiveSection();
  }

  @override
  void didUpdateWidget(OwnerDrawerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentBranchIndex != widget.currentBranchIndex) {
      _autoExpandActiveSection();
    }
  }

  void _autoExpandActiveSection() {
    final entries = OwnerDrawerConfig.getEntries();
    for (final entry in entries) {
      if (entry is DrawerNavSection) {
        if (entry.containsBranchIndex(widget.currentBranchIndex)) {
          _expandedSectionKeys.add(entry.titleKey);
        }
      }
    }
  }

  void _toggleSection(String key) {
    setState(() {
      if (_expandedSectionKeys.contains(key)) {
        _expandedSectionKeys.remove(key);
      } else {
        _expandedSectionKeys.add(key);
      }
    });
  }

  void _handleItemTap(DrawerNavItem item) {
    if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }

    if (item.branchIndex != null) {
      widget.onSelectBranch(item.branchIndex!);
    } else if (item.route != null) {
      context.push(item.route!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final drawerWidth = widget.isCollapsed
        ? 64.0
        : math.min(240.0, screenWidth * 0.75);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        String? accountType;
        if (state is ProfileLoaded) {
          accountType = state.profile.accountType;
        }

        final filteredEntries = OwnerDrawerConfig.getFilteredEntries(accountType);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: drawerWidth,
          child: Drawer(
            elevation: 0,
            backgroundColor: context.appSurfaceColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.horizontal(end: Radius.circular(24)),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OwnerDrawerHeader(isCollapsed: widget.isCollapsed),
                  if (widget.onToggleCollapse != null)
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: IconButton(
                          iconSize: 16,
                          icon: Icon(
                            widget.isCollapsed
                                ? Icons.chevron_right_rounded
                                : Icons.chevron_left_rounded,
                            color: context.appSecondaryTextColor,
                          ),
                          onPressed: widget.onToggleCollapse,
                        ),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.md),
                      itemCount: filteredEntries.length,
                      itemBuilder: (context, index) {
                        final entry = filteredEntries[index];
                        if (entry is DrawerNavItem) {
                          final isSelected =
                              entry.branchIndex == widget.currentBranchIndex;
                          return OwnerDrawerItemWidget(
                            item: entry,
                            isSelected: isSelected,
                            isCollapsed: widget.isCollapsed,
                            onTap: () => _handleItemTap(entry),
                          );
                        } else if (entry is DrawerNavSection) {
                          final isExpanded =
                              _expandedSectionKeys.contains(entry.titleKey);
                          return OwnerDrawerSectionWidget(
                            section: entry,
                            currentBranchIndex: widget.currentBranchIndex,
                            isExpanded: isExpanded,
                            isCollapsed: widget.isCollapsed,
                            onToggle: () => _toggleSection(entry.titleKey),
                            onItemTap: _handleItemTap,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  OwnerDrawerFooter(
                    currentBranchIndex: widget.currentBranchIndex,
                    isCollapsed: widget.isCollapsed,
                    onSelectBranch: widget.onSelectBranch,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
