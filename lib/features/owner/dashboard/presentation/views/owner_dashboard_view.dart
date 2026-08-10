import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/owner_dashboard_cubit.dart';
import '../cubit/owner_dashboard_state.dart';
import '../widgets/owner_alerts_grid.dart';

import '../widgets/owner_occupancy_card.dart';
import '../widgets/owner_dashboard_header.dart';
import '../widgets/owner_dashboard_skeleton_widget.dart';
import '../widgets/owner_quick_actions.dart';
import '../widgets/owner_finance_carousel_widget.dart';
import '../widgets/owner_latest_overdue_section.dart';
import '../widgets/owner_tasks_legal_card.dart';

class OwnerDashboardView extends StatefulWidget {
  const OwnerDashboardView({super.key});

  @override
  State<OwnerDashboardView> createState() => _OwnerDashboardViewState();
}

class _OwnerDashboardViewState extends State<OwnerDashboardView> {
  bool _isRetrying = false;
  @override
  void initState() {
    super.initState();
    final cubit = context.read<OwnerDashboardCubit>();
    if (cubit.state is OwnerDashboardInitial) {
      cubit.loadDashboardStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ColoredBox(
        color: const Color(0xFFF8FAFC),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<OwnerDashboardCubit, OwnerDashboardState>(
                builder: (context, state) {
                  if (state is OwnerDashboardLoading) return _buildLoading();
                  if (state is OwnerDashboardError) {
                    return _buildError(context, state.message);
                  }
                  if (state is OwnerDashboardLoaded) {
                    return _buildContent(context, state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const OwnerDashboardHeader();
  }

  Widget _buildContent(BuildContext context, OwnerDashboardLoaded state) {
    return RefreshIndicator(
      onRefresh: () => context.read<OwnerDashboardCubit>().loadDashboardStats(
        forceRefresh: true,
      ),
      color: context.primaryColor,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
        children: [
          OwnerFinanceCarouselWidget(data: state.data),
          const SizedBox(height: 16),
          OwnerOccupancyCard(data: state.data),
          const SizedBox(height: 16),
          const OwnerQuickActions(),
          const SizedBox(height: 16),
          OwnerAlertsGrid(data: state.data),
          if (state.data.latestOverdueInstallments.isNotEmpty) ...[
            const SizedBox(height: 16),
            OwnerLatestOverdueSection(installments: state.data.latestOverdueInstallments),
          ],
          if (state.data.tasksBreakdown != null || state.data.legalCasesBreakdown != null) ...[
            const SizedBox(height: 16),
            OwnerTasksLegalCard(
              tasks: state.data.tasksBreakdown,
              legalCases: state.data.legalCasesBreakdown,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const OwnerDashboardSkeletonWidget();
  }

  Widget _buildError(BuildContext context, String message) {
    return CustomErrorWidget(
      message: message,
      isLoading: _isRetrying,
      onRetry: () async {
        setState(() => _isRetrying = true);
        await context.read<OwnerDashboardCubit>().loadDashboardStats(
          forceRefresh: true,
          showLoadingState: false,
        );
        if (mounted) {
          setState(() => _isRetrying = false);
        }
      },
    );
  }
}
