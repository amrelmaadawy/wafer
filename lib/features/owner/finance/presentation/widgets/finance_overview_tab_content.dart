import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../cubit/finance_overview_cubit.dart';
import '../cubit/finance_overview_state.dart';
import 'finance_overview_skeleton.dart';
import 'finance_summary_card.dart';
import 'finance_resources_grid.dart';

class FinanceOverviewTabContent extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const FinanceOverviewTabContent({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: context.primaryColor,
      child: BlocBuilder<FinanceOverviewCubit, FinanceOverviewState>(
        builder: (context, state) {
          if (state is FinanceOverviewLoading) {
            return const SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: FinanceOverviewSkeletonWidget(),
            );
          } else if (state is FinanceOverviewError) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: CustomErrorWidget(
                message: state.message,
                onRetry: onRefresh,
              ),
            );
          } else if (state is FinanceOverviewLoaded) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FinanceSummaryCardWidget(summary: state.overview.summary),
                  const SizedBox(height: 24),
                  FinanceResourcesGridWidget(overview: state.overview),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
