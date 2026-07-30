import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../../../../../core/services/pdf/builders/employee_tasks_pdf_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../../../../../core/services/excel/builders/employee_tasks_excel_builder.dart';
import '../../../../../core/di/service_locator.dart';
import '../cubit/owner_employee_tasks_cubit.dart';
import '../cubit/owner_employee_tasks_state.dart';
import '../widgets/employee_tasks_summary_header.dart';
import '../widgets/employee_tasks_report_list.dart';
import '../widgets/report_skeleton.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/report_export_button.dart';

class OwnerEmployeeTasksReportView extends StatefulWidget {
  const OwnerEmployeeTasksReportView({super.key});

  @override
  State<OwnerEmployeeTasksReportView> createState() =>
      _OwnerEmployeeTasksReportViewState();
}

class _OwnerEmployeeTasksReportViewState
    extends State<OwnerEmployeeTasksReportView> {
  final _scrollController = ScrollController();
  late OwnerEmployeeTasksCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<OwnerEmployeeTasksCubit>()..fetchReport();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) _cubit.fetchReport();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
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
        appBar: CustomAppBar(
          title: LocaleKeys.employeeTasksTitle.tr(),
          actions: [
            BlocBuilder<OwnerEmployeeTasksCubit, OwnerEmployeeTasksState>(
              builder: (context, state) {
                if (state is OwnerEmployeeTasksLoaded) {
                  return ReportExportButton(
                    onPdfPressed: () async {
                      final pdf = await EmployeeTasksPdfBuilder.build(
                        state.report.summary,
                        state.report.items,
                      );
                      if (context.mounted) {
                        await PdfGeneratorService.exportAndPrint(
                          context: context,
                          pdf: pdf,
                          fileName: 'تقرير_مهام_الموظفين.pdf',
                        );
                      }
                    },
                    onExcelPressed: () async {
                      final bytes = await EmployeeTasksExcelBuilder.build(
                        state.report.summary,
                        state.report.items,
                      );
                      if (context.mounted) {
                        await ExcelExportService.saveAndShare(
                          context: context,
                          bytes: bytes,
                          fileName: 'تقرير_مهام_الموظفين.xlsx',
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
        body: BlocBuilder<OwnerEmployeeTasksCubit, OwnerEmployeeTasksState>(
          builder: (context, state) {
            if (state is OwnerEmployeeTasksInitial ||
                (state is OwnerEmployeeTasksLoading && !state.isPagination)) {
              return const ReportSkeleton();
            }

            if (state is OwnerEmployeeTasksError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => _cubit.fetchReport(forceRefresh: true),
              );
            }

            if (state is OwnerEmployeeTasksEmpty) {
              return ReportEmptyWidget(
                message: LocaleKeys.employeeTasksNoData.tr(),
                icon: Icons.assignment_ind_outlined,
              );
            }

            if (state is OwnerEmployeeTasksLoaded ||
                (state is OwnerEmployeeTasksLoading && state.isPagination)) {
              final report = state is OwnerEmployeeTasksLoaded
                  ? state.report
                  : (context.read<OwnerEmployeeTasksCubit>().state
                            as OwnerEmployeeTasksLoaded)
                        .report;

              final isLoading =
                  state is OwnerEmployeeTasksLoading && state.isPagination;

              return RefreshIndicator(
                onRefresh: () => _cubit.fetchReport(forceRefresh: true),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EmployeeTasksSummaryHeader(summary: report.summary),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              LocaleKeys.employeeTasksList.tr(),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    EmployeeTasksReportList(items: report.items),
                    if (isLoading)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
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
