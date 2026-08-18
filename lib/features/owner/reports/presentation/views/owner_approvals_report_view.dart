import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/services/excel/builders/approvals_excel_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../../../../../core/services/pdf/builders/approvals_pdf_builder.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../cubit/owner_approvals_report_cubit.dart';
import '../cubit/owner_approvals_report_state.dart';
import '../widgets/approvals/approval_item_card.dart';
import '../widgets/approvals/approvals_report_skeleton.dart';
import '../widgets/approvals/approvals_summary_cards.dart';
import '../widgets/filter/report_status_chip.dart';
import '../widgets/filter/universal_reports_filter_bar.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/report_export_button.dart';

class OwnerApprovalsReportView extends StatefulWidget {
  const OwnerApprovalsReportView({super.key});

  @override
  State<OwnerApprovalsReportView> createState() =>
      _OwnerApprovalsReportViewState();
}

class _OwnerApprovalsReportViewState extends State<OwnerApprovalsReportView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<OwnerApprovalsReportCubit>().fetchReport(isRefresh: true);
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
      context.read<OwnerApprovalsReportCubit>().fetchReport();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<OwnerApprovalsReportCubit>().fetchReport(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OwnerApprovalsReportCubit>();
    final statuses = [
      ReportStatusItem(
        value: 'APPROVED',
        label: LocaleKeys.ownerReportsApproved.tr(),
      ),
      ReportStatusItem(
        value: 'PENDING',
        label: LocaleKeys.ownerReportsPending.tr(),
      ),
      ReportStatusItem(
        value: 'REJECTED',
        label: LocaleKeys.ownerReportsRejected.tr(),
      ),
    ];

    return Scaffold(
      backgroundColor: context.appBackgroundColor,
      appBar: CustomAppBar(
        title: LocaleKeys.ownerReportsApprovals.tr(),
        actions: [
          BlocBuilder<OwnerApprovalsReportCubit, OwnerApprovalsReportState>(
            builder: (context, state) {
              if (state is OwnerApprovalsReportLoaded) {
                return ReportExportButton(
                  onPdfPressed: () async {
                    final pdf = await ApprovalsPdfBuilder.build(state.report);
                    if (context.mounted) {
                      await PdfGeneratorService.exportAndPrint(
                        context: context,
                        pdf: pdf,
                        fileName: 'تقرير_الموافقات.pdf',
                      );
                    }
                  },
                  onExcelPressed: () async {
                    final bytes = await ApprovalsExcelBuilder.build(
                      state.report,
                    );
                    if (context.mounted) {
                      await ExcelExportService.saveAndShare(
                        context: context,
                        bytes: bytes,
                        fileName: 'تقرير_الموافقات.xlsx',
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
      body: BlocBuilder<OwnerApprovalsReportCubit, OwnerApprovalsReportState>(
        builder: (context, state) {
          if (state is OwnerApprovalsReportInitial ||
              (state is OwnerApprovalsReportLoading && state.isFirstFetch)) {
            return const ApprovalsReportSkeleton();
          }

          if (state is OwnerApprovalsReportError) {
            return CustomErrorWidget(message: state.message, onRetry: _onRefresh);
          }

          if (state is OwnerApprovalsReportEmpty) {
            return ReportEmptyWidget(
              message: LocaleKeys.reports_noData.tr(),
              icon: Icons.checklist_rtl,
            );
          }

          if (state is OwnerApprovalsReportLoaded ||
              (state is OwnerApprovalsReportLoading && !state.isFirstFetch)) {
            final reportData = state is OwnerApprovalsReportLoaded
                ? state.report
                : (state as OwnerApprovalsReportLoading).report;
            if (reportData == null) return const ApprovalsReportSkeleton();

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
                        showStatus: true,
                        selectedStatus: cubit.selectedStatus,
                        statuses: statuses,
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
                        ApprovalsSummaryCards(summary: reportData.summary),
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
                          return ApprovalItemCard(item: reportData.items[index]);
                        },
                        childCount: state is OwnerApprovalsReportLoading
                            ? reportData.items.length + 1
                            : reportData.items.length,
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
