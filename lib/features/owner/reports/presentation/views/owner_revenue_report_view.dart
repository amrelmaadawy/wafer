import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/owner_revenue_cubit.dart';
import '../cubit/owner_revenue_state.dart';
import '../widgets/revenue_animated_bar_chart.dart';
import '../widgets/revenue_monthly_list.dart';
import '../widgets/revenue_skeleton.dart';
import '../widgets/revenue_summary_header.dart';

class OwnerRevenueReportView extends StatelessWidget {
  const OwnerRevenueReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerRevenueCubit, OwnerRevenueState>(
      builder: (context, state) {
        if (state is OwnerRevenueLoading || state is OwnerRevenueInitial) {
          return const SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: RevenueSkeleton(),
          );
        } else if (state is OwnerRevenueError) {
          return _buildErrorView(context, state.message);
        } else if (state is OwnerRevenueEmpty) {
          return _buildEmptyView(context);
        } else if (state is OwnerRevenueLoaded) {
          return RefreshIndicator(
            color: context.primaryColor,
            onRefresh: () => context
                .read<OwnerRevenueCubit>()
                .loadRevenueReport(forceRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RevenueSummaryHeader(
                    totalExpected: state.totalExpected,
                    totalCollected: state.totalCollected,
                    collectionRate: state.collectionRate,
                  ),
                  const SizedBox(height: 16),
                  RevenueAnimatedBarChart(entries: state.entries),
                  const SizedBox(height: 16),
                  RevenueMonthlyList(entries: state.entries),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 56, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textPrimaryLight, fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context
                  .read<OwnerRevenueCubit>()
                  .loadRevenueReport(forceRefresh: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.circularFull),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(LocaleKeys.commonRetry.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_balance_wallet_outlined,
              size: 56, color: AppColors.textSecondaryLight),
          const SizedBox(height: 16),
          Text(LocaleKeys.revenueNoData.tr(),
              style: const TextStyle(
                  color: AppColors.textSecondaryLight, fontSize: 16)),
        ],
      ),
    );
  }
}
