import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/owner_dashboard_cubit.dart';
import '../cubit/owner_dashboard_state.dart';
import '../widgets/owner_alerts_grid.dart';
import '../widgets/owner_financial_summary_card.dart';
import '../widgets/owner_occupancy_card.dart';
import '../widgets/owner_recent_receipts_section.dart';
import '../widgets/owner_dashboard_header.dart';
import '../widgets/owner_quick_actions.dart';

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
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
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
          OwnerRecentReceiptsSection(receipts: state.data.recentReceipts),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 48),
            const SizedBox(height: 14),
            Text(message, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 15, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.read<OwnerDashboardCubit>().loadDashboardStats(forceRefresh: true),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(LocaleKeys.commonRetry.tr()),
              style: ElevatedButton.styleFrom(backgroundColor: context.primaryColor, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
