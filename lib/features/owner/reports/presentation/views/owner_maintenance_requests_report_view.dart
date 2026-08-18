import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/di/service_locator.dart';
import '../cubit/owner_maintenance_requests_cubit.dart';
import '../cubit/owner_maintenance_requests_state.dart';
import '../widgets/maintenance_requests_summary_header.dart';
import '../widgets/maintenance_requests_report_list.dart';
import '../widgets/report_skeleton.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/report_export_button.dart';
import '../../../../../core/services/pdf/builders/maintenance_requests_pdf_builder.dart';
import '../../../../../core/services/excel/builders/maintenance_requests_excel_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../widgets/filter/report_status_chip.dart';
import '../widgets/filter/universal_reports_filter_bar.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';

class OwnerMaintenanceRequestsReportView extends StatefulWidget {
  const OwnerMaintenanceRequestsReportView({super.key});

  @override
  State<OwnerMaintenanceRequestsReportView> createState() =>
      _OwnerMaintenanceRequestsReportViewState();
}

class _OwnerMaintenanceRequestsReportViewState
    extends State<OwnerMaintenanceRequestsReportView> {
  late final OwnerMaintenanceRequestsCubit _cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = sl<OwnerMaintenanceRequestsCubit>();
    _cubit.loadReport();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.loadReport();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: CustomAppBar(
          title: LocaleKeys.maintenanceRequestsTitle.tr(),
          actions: [
            BlocBuilder<
              OwnerMaintenanceRequestsCubit,
              OwnerMaintenanceRequestsState
            >(
              builder: (context, state) {
                if (state is OwnerMaintenanceRequestsLoaded) {
                  return ReportExportButton(
                    onPdfPressed: () async {
                      final pdf = await MaintenanceRequestsPdfBuilder.build(
                        state.report.summary,
                        state.report.items,
                      );
                      if (context.mounted) {
                        await PdfGeneratorService.exportAndPrint(
                          context: context,
                          pdf: pdf,
                          fileName: 'تقرير_طلبات_الصيانة.pdf',
                        );
                      }
                    },
                    onExcelPressed: () async {
                      final bytes = await MaintenanceRequestsExcelBuilder.build(
                        state.report.summary,
                        state.report.items,
                      );
                      if (context.mounted) {
                        await ExcelExportService.saveAndShare(
                          context: context,
                          bytes: bytes,
                          fileName: 'تقرير_طلبات_الصيانة.xlsx',
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
        body:
            BlocBuilder<
              OwnerMaintenanceRequestsCubit,
              OwnerMaintenanceRequestsState
            >(
              builder: (context, state) {
                if (state is OwnerMaintenanceRequestsInitial ||
                    (state is OwnerMaintenanceRequestsLoading &&
                        !state.isPagination)) {
                  return const ReportSkeleton();
                } else if (state is OwnerMaintenanceRequestsError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () => _cubit.loadReport(refresh: true),
                  );
                } else if (state is OwnerMaintenanceRequestsEmpty) {
                  return ReportEmptyWidget(
                    message: LocaleKeys.maintenanceRequestsNoData.tr(),
                    icon: Icons.build_circle_outlined,
                  );
                } else if (state is OwnerMaintenanceRequestsLoaded ||
                    (state is OwnerMaintenanceRequestsLoading &&
                        state.isPagination)) {
                  final currentState = _cubit.state;
                  if (currentState is! OwnerMaintenanceRequestsLoaded &&
                      currentState is! OwnerMaintenanceRequestsLoading) {
                    return const SizedBox.shrink();
                  }

                  var report = (currentState is OwnerMaintenanceRequestsLoaded)
                      ? currentState.report
                      : null;

                  if (report == null) return const SizedBox.shrink();

                  final statuses = [
                    ReportStatusItem(value: 'OPEN', label: LocaleKeys.maintenanceRequestsOpen.tr()),
                    ReportStatusItem(value: 'IN_PROGRESS', label: LocaleKeys.maintenanceRequestsInProgress.tr()),
                    ReportStatusItem(value: 'COMPLETED', label: LocaleKeys.maintenanceRequestsCompleted.tr()),
                  ];

                  return RefreshIndicator(
                    onRefresh: () => _cubit.loadReport(refresh: true),
                    color: context.primaryColor,
                    child: ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      children: [
                        UniversalReportsFilterBar(
                          showDateRange: true,
                          selectedStartDate: _cubit.selectedStartDate,
                          selectedEndDate: _cubit.selectedEndDate,
                          onDateRangeSelected: (start, end) {
                            _cubit.loadReport(
                              refresh: true,
                              startDate: start,
                              endDate: end,
                            );
                          },
                          showStatus: true,
                          selectedStatus: _cubit.selectedStatus,
                          statuses: statuses,
                          onStatusSelected: (status) {
                            _cubit.loadReport(
                              refresh: true,
                              status: status,
                            );
                          },
                          hasActiveFilters: _cubit.hasActiveFilters,
                          onReset: _cubit.clearFilters,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: MaintenanceRequestsSummaryHeader(
                            summary: report.summary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            LocaleKeys.maintenanceRequestsList.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: MaintenanceRequestsReportList(items: report.items),
                        ),
                        if (currentState is OwnerMaintenanceRequestsLoading &&
                            currentState.isPagination) ...[
                          const SizedBox(height: 16),
                          const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
      ),
    );
  }
}
