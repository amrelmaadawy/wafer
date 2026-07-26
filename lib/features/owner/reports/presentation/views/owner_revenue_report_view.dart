import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/features/owner/reports/presentation/widgets/report_export_button.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../cubit/owner_revenue_cubit.dart';
import '../cubit/owner_revenue_state.dart';
import '../widgets/revenue_animated_bar_chart.dart';
import '../widgets/revenue_monthly_list.dart';
import '../widgets/revenue_skeleton.dart';
import '../widgets/revenue_summary_header.dart';
import '../widgets/reports_filter_bar.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../../../../../core/services/pdf/builders/revenue_pdf_builder.dart';

class OwnerRevenueReportView extends StatelessWidget {
  const OwnerRevenueReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: LocaleKeys.revenueReport.tr(),
        actions: [
          BlocBuilder<OwnerRevenueCubit, OwnerRevenueState>(
            builder: (context, state) {
              if (state is OwnerRevenueLoaded) {
                return ReportExportButton(
                  onPressed: () async {
                    final pdf = await RevenuePdfBuilder.build(state.report);
                    if (context.mounted) {
                      await PdfGeneratorService.exportAndPrint(
                        context: context,
                        pdf: pdf,
                        fileName: 'تقرير_الإيرادات.pdf',
                      );
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<OwnerRevenueCubit, OwnerRevenueState>(
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
          final cubit = context.read<OwnerRevenueCubit>();
          return RefreshIndicator(
            color: context.primaryColor,
            onRefresh: () => cubit.loadRevenueReport(forceRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ReportsFilterBar(
                    filterOptions: state.report.filterOptions,
                    selectedPropertyId: cubit.selectedPropertyId,
                    selectedStartDate: cubit.selectedStartDate,
                    selectedEndDate: cubit.selectedEndDate,
                    onPropertySelected: (id) {
                      cubit.loadRevenueReport(forceRefresh: true, propertyId: id);
                    },
                    onDateRangeSelected: (start, end) {
                      cubit.loadRevenueReport(forceRefresh: true, startDate: start, endDate: end);
                    },
                    onReset: cubit.clearFilters,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RevenueSummaryHeader(summary: state.report.summary),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RevenueAnimatedBarChart(entries: state.report.chart),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RevenueMonthlyList(entries: state.report.chart),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    ));
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return CustomErrorWidget(
      message: message,
      onRetry: () => context
          .read<OwnerRevenueCubit>()
          .loadRevenueReport(forceRefresh: true),
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
