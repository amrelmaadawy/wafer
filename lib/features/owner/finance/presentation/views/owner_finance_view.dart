import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../cubit/finance_overview_cubit.dart';
import '../cubit/finance_overview_state.dart';
import '../widgets/finance_overview_skeleton.dart';
import '../widgets/finance_summary_card.dart';
import '../widgets/finance_resources_grid.dart';

class OwnerFinanceView extends StatefulWidget {
  const OwnerFinanceView({super.key});

  @override
  State<OwnerFinanceView> createState() => _OwnerFinanceViewState();
}

class _OwnerFinanceViewState extends State<OwnerFinanceView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<FinanceOverviewCubit>();
    if (cubit.state is FinanceOverviewInitial) {
      cubit.fetchFinanceOverview();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<FinanceOverviewCubit>().fetchFinanceOverview(
      isRefresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        LocaleKeys.owner_finance_title.tr(),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryLight,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        LocaleKeys.owner_finance_subtitle.tr(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: BlocBuilder<FinanceOverviewCubit, FinanceOverviewState>(
                  builder: (context, state) {
                    if (state is FinanceOverviewLoading) {
                      return const FinanceOverviewSkeletonWidget();
                    } else if (state is FinanceOverviewError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomErrorWidget(
                          message: state.message,
                          onRetry: _onRefresh,
                        ),
                      );
                    } else if (state is FinanceOverviewLoaded) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FinanceSummaryCardWidget(
                              summary: state.overview.summary,
                            ),
                            const SizedBox(height: 24),
                            FinanceResourcesGridWidget(
                              overview: state.overview,
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
