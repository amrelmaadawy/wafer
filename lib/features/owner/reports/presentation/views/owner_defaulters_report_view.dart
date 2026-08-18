import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/owner_defaulters_cubit.dart';
import '../cubit/owner_defaulters_state.dart';
import '../widgets/defaulters_summary_header.dart';
import '../widgets/defaulters_report_list.dart';
import '../widgets/report_skeleton.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/report_export_button.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../../../../../core/services/pdf/builders/defaulters_pdf_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../widgets/filter/universal_reports_filter_bar.dart';
import '../../../../../core/services/excel/builders/defaulters_excel_builder.dart';

class OwnerDefaultersReportView extends StatefulWidget {
  const OwnerDefaultersReportView({super.key});

  @override
  State<OwnerDefaultersReportView> createState() =>
      _OwnerDefaultersReportViewState();
}

class _OwnerDefaultersReportViewState extends State<OwnerDefaultersReportView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OwnerDefaultersCubit>().loadDefaultersReport();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: LocaleKeys.defaultersReportTitle.tr(),
        actions: [
          BlocBuilder<OwnerDefaultersCubit, OwnerDefaultersState>(
            builder: (context, state) {
              if (state is OwnerDefaultersLoaded) {
                return ReportExportButton(
                  onPdfPressed: () async {
                    final pdf = await DefaultersPdfBuilder.build(
                      state.report.items,
                      state.report.summary.totalRemaining,
                      state.report.summary.totalAmount,
                      state.report.summary.totalInstallments,
                    );
                    if (context.mounted) {
                      await PdfGeneratorService.exportAndPrint(
                        context: context,
                        pdf: pdf,
                        fileName: 'تقرير_المتأخرات.pdf',
                      );
                    }
                  },
                  onExcelPressed: () async {
                    final bytes = await DefaultersExcelBuilder.build(
                      state.report.items,
                      state.report.summary.totalRemaining,
                      state.report.summary.totalAmount,
                      state.report.summary.totalInstallments,
                    );
                    if (context.mounted) {
                      await ExcelExportService.saveAndShare(
                        context: context,
                        bytes: bytes,
                        fileName: 'تقرير_المتأخرات.xlsx',
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
      body: BlocBuilder<OwnerDefaultersCubit, OwnerDefaultersState>(
        builder: (context, state) {
          if (state is OwnerDefaultersLoading &&
              context.read<OwnerDefaultersCubit>().state
                  is! OwnerDefaultersLoaded) {
            return const ReportSkeleton();
          } else if (state is OwnerDefaultersError) {
            return _buildErrorView(context, state.message);
          } else if (state is OwnerDefaultersEmpty) {
            return ReportEmptyWidget(
              message: LocaleKeys.defaultersNoData.tr(),
              icon: Icons.check_circle_outline_rounded,
              color: AppColors.success,
            );
          } else if (state is OwnerDefaultersLoaded) {
            final cubit = context.read<OwnerDefaultersCubit>();
            return RefreshIndicator(
              color: context.primaryColor,
              onRefresh: () => cubit.loadDefaultersReport(forceRefresh: true),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    UniversalReportsFilterBar(
                      showDateRange: true,
                      selectedStartDate: cubit.selectedStartDate,
                      selectedEndDate: cubit.selectedEndDate,
                      onDateRangeSelected: (start, end) {
                        cubit.loadDefaultersReport(
                          forceRefresh: true,
                          startDate: start,
                          endDate: end,
                        );
                      },
                      hasActiveFilters: cubit.hasActiveFilters,
                      onReset: cubit.clearFilters,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DefaultersSummaryHeader(
                        totalRemaining: state.report.summary.totalRemaining,
                        totalAmount: state.report.summary.totalAmount,
                        totalInstallments: state.report.summary.totalInstallments,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      LocaleKeys.defaultersList.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DefaultersReportList(items: state.report.items),
                    if (!state.hasReachedMax)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return CustomErrorWidget(
      message: message,
      onRetry: () => context.read<OwnerDefaultersCubit>().loadDefaultersReport(
        forceRefresh: true,
      ),
    );
  }
}
