import 'package:flutter/material.dart';
import '../../../../../core/theme/app_breakpoints.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../cubit/owner_dashboard_state.dart';
import 'owner_critical_alerts_section.dart';
import 'owner_pending_actions_section.dart';
import 'owner_finance_carousel_widget.dart';
import 'owner_occupancy_card.dart';
import 'owner_quick_actions.dart';

class OwnerDashboardContent extends StatelessWidget {
  final OwnerDashboardLoaded state;

  const OwnerDashboardContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (!context.isExpanded) {
      return _DashboardColumn(children: _sections);
    }
    return _buildExpandedLayout(context);
  }

  List<Widget> get _sections => [
    OwnerFinanceCarouselWidget(data: state.data),
    OwnerOccupancyCard(data: state.data),
    OwnerCriticalAlertsSection(data: state.data),
    OwnerPendingActionsSection(data: state.data),
    const OwnerQuickActions(),
  ];

  Widget _buildExpandedLayout(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: OwnerFinanceCarouselWidget(data: state.data)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: OwnerOccupancyCard(data: state.data)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        OwnerCriticalAlertsSection(data: state.data),
        const SizedBox(height: AppSpacing.md),
        OwnerPendingActionsSection(data: state.data),
        const SizedBox(height: AppSpacing.md),
        const OwnerQuickActions(),
      ],
    );
  }
}

class _DashboardColumn extends StatelessWidget {
  final List<Widget> children;

  const _DashboardColumn({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.md),
          children[index],
        ],
      ],
    );
  }
}
