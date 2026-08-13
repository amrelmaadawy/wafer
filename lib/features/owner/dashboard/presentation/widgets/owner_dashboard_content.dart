import 'package:flutter/material.dart';
import '../../../../../core/theme/app_breakpoints.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../cubit/owner_dashboard_state.dart';
import 'owner_alerts_grid.dart';
import 'owner_finance_carousel_widget.dart';
import 'owner_latest_overdue_section.dart';
import 'owner_occupancy_card.dart';
import 'owner_quick_actions.dart';
import 'owner_tasks_legal_card.dart';

class OwnerDashboardContent extends StatelessWidget {
  final OwnerDashboardLoaded state;

  const OwnerDashboardContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (!context.isExpanded) {
      return _DashboardColumn(children: _sections);
    }
    final supportingSections = _supportingSections;
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
        const OwnerQuickActions(),
        const SizedBox(height: AppSpacing.md),
        OwnerAlertsGrid(data: state.data),
        if (supportingSections.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (
                var index = 0;
                index < supportingSections.length;
                index++
              ) ...[
                if (index > 0) const SizedBox(width: AppSpacing.md),
                Expanded(child: supportingSections[index]),
              ],
            ],
          ),
        ],
      ],
    );
  }

  List<Widget> get _sections => [
    OwnerFinanceCarouselWidget(data: state.data),
    OwnerOccupancyCard(data: state.data),
    const OwnerQuickActions(),
    OwnerAlertsGrid(data: state.data),
    ..._supportingSections,
  ];

  List<Widget> get _supportingSections => [
    if (state.data.latestOverdueInstallments.isNotEmpty)
      OwnerLatestOverdueSection(
        installments: state.data.latestOverdueInstallments,
      ),
    if (state.data.tasksBreakdown != null ||
        state.data.legalCasesBreakdown != null)
      OwnerTasksLegalCard(
        tasks: state.data.tasksBreakdown,
        legalCases: state.data.legalCasesBreakdown,
      ),
  ];
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
