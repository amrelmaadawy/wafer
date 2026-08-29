import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../domain/entities/warehouse_summary_entity.dart';
import 'cubit/summary/owner_warehouse_summary_cubit.dart';
import 'cubit/summary/owner_warehouse_summary_state.dart';
import 'widgets/low_stock_item_card.dart';
import 'widgets/warehouse_movement_card.dart';
import 'widgets/warehouse_stats_grid.dart';
import 'widgets/warehouse_summary_shimmer.dart';

class OwnerWarehouseSummaryView extends StatefulWidget {
  const OwnerWarehouseSummaryView({super.key});

  @override
  State<OwnerWarehouseSummaryView> createState() =>
      _OwnerWarehouseSummaryViewState();
}

class _OwnerWarehouseSummaryViewState extends State<OwnerWarehouseSummaryView> {
  late final OwnerWarehouseSummaryCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<OwnerWarehouseSummaryCubit>()..fetchSummary();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: CustomAppBar(
          title: LocaleKeys.warehouse_dashboard_title.tr(),
          showBackButton: false,
          showMenuButton: true,
        ),
        body:
            BlocBuilder<OwnerWarehouseSummaryCubit, OwnerWarehouseSummaryState>(
              builder: (context, state) {
                if (state is OwnerWarehouseSummaryLoading) {
                  return const WarehouseSummaryShimmer();
                } else if (state is OwnerWarehouseSummaryFailure) {
                  return CustomErrorWidget(
                    title: LocaleKeys.common_error.tr(),
                    message: state.message,
                    onRetry: _cubit.fetchSummary,
                  );
                } else if (state is OwnerWarehouseSummarySuccess) {
                  return _buildContent(context, state.summary);
                }
                return const SizedBox.shrink();
              },
            ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WarehouseSummaryEntity summary) {
    return RefreshIndicator(
      onRefresh: () => _cubit.fetchSummary(),
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WarehouseStatsGrid(stats: summary.stats),
            const SizedBox(height: AppSpacing.xl),

            // Low Stock Section
            _buildSectionTitle(LocaleKeys.warehouse_low_stock_title.tr()),
            const SizedBox(height: AppSpacing.md),
            if (summary.lowStockItems.isEmpty)
              CustomEmptyWidget(
                title: LocaleKeys.warehouse_low_stock_empty.tr(),
                subtitle: LocaleKeys.warehouse_low_stock_empty_sub.tr(),
                icon: Icons.check_circle_outline,
              )
            else
              ...summary.lowStockItems.map(
                (item) => LowStockItemCard(item: item),
              ),

            const SizedBox(height: AppSpacing.xl),

            // Recent Movements Section
            _buildSectionTitle(
              LocaleKeys.warehouse_recent_movements_title.tr(),
            ),
            const SizedBox(height: AppSpacing.md),
            if (summary.recentMovements.isEmpty)
              CustomEmptyWidget(
                title: LocaleKeys.warehouse_recent_movements_empty.tr(),
                subtitle: LocaleKeys.warehouse_recent_movements_empty_sub.tr(),
                icon: Icons.description_outlined,
              )
            else
              ...summary.recentMovements.map(
                (mov) => WarehouseMovementCard(movement: mov),
              ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.h4.copyWith());
  }
}
