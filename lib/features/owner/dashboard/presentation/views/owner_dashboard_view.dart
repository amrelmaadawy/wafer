import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/owner_dashboard_cubit.dart';
import '../cubit/owner_dashboard_state.dart';
import '../widgets/owner_alerts_grid.dart';
import '../widgets/owner_financial_summary_card.dart';
import '../widgets/owner_occupancy_card.dart';
import '../widgets/owner_recent_receipts_section.dart';
import '../widgets/owner_dashboard_header.dart';
import '../widgets/owner_dashboard_skeleton_widget.dart';
import '../widgets/owner_quick_actions.dart';
import '../widgets/owner_maintenance_hub_section.dart';

class OwnerDashboardView extends StatefulWidget {
  const OwnerDashboardView({super.key});

  @override
  State<OwnerDashboardView> createState() => _OwnerDashboardViewState();
}

class _OwnerDashboardViewState extends State<OwnerDashboardView> {
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
                  if (state is OwnerDashboardError) return _buildError(context, state.message);
                  if (state is OwnerDashboardLoaded) return _buildContent(context, state);
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
      onRefresh: () => context.read<OwnerDashboardCubit>().loadDashboardStats(forceRefresh: true),
      color: context.primaryColor,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
        children: [
          OwnerFinancialSummaryCard(data: state.data),
          const SizedBox(height: 16),
          OwnerOccupancyCard(data: state.data),
          const SizedBox(height: 16),
          const OwnerQuickActions(),
          const SizedBox(height: 16),
          OwnerAlertsGrid(data: state.data),
          const SizedBox(height: 16),
          OwnerMaintenanceHubSection(
            pendingCount: state.data.pendingMaintenance,
            recentItems: const [],
          ),
          const SizedBox(height: 16),
          OwnerRecentReceiptsSection(receipts: state.data.recentReceipts),
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
      onRetry: () => context.read<OwnerDashboardCubit>().loadDashboardStats(forceRefresh: true),
    );
  }
}
