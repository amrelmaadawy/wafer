import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/services/excel/builders/legal_cases_excel_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../../../../../core/services/pdf/builders/legal_cases_pdf_builder.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../cubit/legal_cases/owner_legal_cases_report_cubit.dart';
import '../cubit/legal_cases/owner_legal_cases_report_state.dart';
import '../widgets/filter/report_status_chip.dart';
import '../widgets/filter/universal_reports_filter_bar.dart';
import '../widgets/legal_cases/legal_case_card.dart';
import '../widgets/legal_cases/legal_cases_report_skeleton.dart';
import '../widgets/legal_cases/legal_cases_summary_cards.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/report_export_button.dart';

class OwnerLegalCasesReportView extends StatefulWidget {
  const OwnerLegalCasesReportView({super.key});

  @override
  State<OwnerLegalCasesReportView> createState() =>
      _OwnerLegalCasesReportViewState();
}

class _OwnerLegalCasesReportViewState extends State<OwnerLegalCasesReportView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<OwnerLegalCasesReportCubit>().fetchReport(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OwnerLegalCasesReportCubit>().fetchReport();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<OwnerLegalCasesReportCubit>().fetchReport(
      isRefresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OwnerLegalCasesReportCubit>();

    return Scaffold(
      backgroundColor: context.appBackgroundColor,
      appBar: CustomAppBar(
        title: LocaleKeys.reports_legalCases.tr(),
        actions: [
          BlocBuilder<OwnerLegalCasesReportCubit, OwnerLegalCasesReportState>(
            builder: (context, state) {
              if (state is OwnerLegalCasesReportLoaded) {
                return ReportExportButton(
                  onPdfPressed: () async {
                    final pdf = await LegalCasesPdfBuilder.build(
                      state.report.items,
                      state.report.summary,
                    );
                    if (context.mounted) {
                      await PdfGeneratorService.exportAndPrint(
                        context: context,
                        pdf: pdf,
                        fileName: 'legal_cases_report.pdf',
                      );
                    }
                  },
                  onExcelPressed: () async {
                    final bytes = await LegalCasesExcelBuilder.build(
                      state.report.items,
                      state.report.summary,
                    );
                    if (context.mounted) {
                      await ExcelExportService.saveAndShare(
                        context: context,
                        bytes: bytes,
                        fileName: 'legal_cases_report.xlsx',
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
      body: BlocBuilder<OwnerLegalCasesReportCubit, OwnerLegalCasesReportState>(
        builder: (context, state) {
          if (state is OwnerLegalCasesReportInitial ||
              (state is OwnerLegalCasesReportLoading && state.isFirstFetch)) {
            return const LegalCasesReportSkeleton();
          }

          if (state is OwnerLegalCasesReportError) {
            return CustomErrorWidget(message: state.message, onRetry: _onRefresh);
          }

          if (state is OwnerLegalCasesReportEmpty) {
            return ReportEmptyWidget(
              message: LocaleKeys.reports_noData.tr(),
              icon: Icons.gavel_rounded,
            );
          }

          if (state is OwnerLegalCasesReportLoaded) {
            final reportData = state.report;
            final statusOptions = reportData.filterOptions.statuses
                .map((s) => ReportStatusItem(value: s.value, label: s.label))
                .toList();

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: context.primaryColor,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: UniversalReportsFilterBar(
                        showDateRange: true,
                        selectedStartDate: cubit.selectedStartDate,
                        selectedEndDate: cubit.selectedEndDate,
                        onDateRangeSelected: (start, end) {
                          cubit.fetchReport(
                            isRefresh: true,
                            startDate: start,
                            endDate: end,
                          );
                        },
                        showStatus: statusOptions.isNotEmpty,
                        selectedStatus: cubit.selectedStatus,
                        statuses: statusOptions,
                        onStatusSelected: (status) {
                          cubit.fetchReport(isRefresh: true, status: status);
                        },
                        hasActiveFilters: cubit.hasActiveFilters,
                        onReset: cubit.clearFilters,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        LegalCasesSummaryCards(summary: reportData.summary),
                        const SizedBox(height: 16),
                      ]),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= reportData.items.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return LegalCaseCard(item: reportData.items[index]);
                        },
                        childCount: reportData.items.length,
                      ),
                    ),
                  ),
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
