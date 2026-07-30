import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../../../../../core/services/pdf/builders/activity_logs_pdf_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../../../../../core/services/excel/builders/activity_logs_excel_builder.dart';
import '../../../../../core/di/service_locator.dart';
import '../cubit/owner_activity_logs_cubit.dart';
import '../cubit/owner_activity_logs_state.dart';
import '../widgets/activity_logs_summary_header.dart';
import '../widgets/activity_logs_report_list.dart';
import '../widgets/report_skeleton.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/report_export_button.dart';

class OwnerActivityLogsReportView extends StatefulWidget {
  const OwnerActivityLogsReportView({super.key});

  @override
  State<OwnerActivityLogsReportView> createState() =>
      _OwnerActivityLogsReportViewState();
}

class _OwnerActivityLogsReportViewState
    extends State<OwnerActivityLogsReportView> {
  final _scrollController = ScrollController();
  late OwnerActivityLogsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<OwnerActivityLogsCubit>()..fetchReport();
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
          title: LocaleKeys.activityLogsTitle.tr(),
          actions: [
            BlocBuilder<OwnerActivityLogsCubit, OwnerActivityLogsState>(
              builder: (context, state) {
                if (state is OwnerActivityLogsLoaded) {
                  return ReportExportButton(
                    onPdfPressed: () async {
                      final pdf = await ActivityLogsPdfBuilder.build(
                        state.report.summary,
                        state.report.items,
                      );
                      if (context.mounted) {
                        await PdfGeneratorService.exportAndPrint(
                          context: context,
                          pdf: pdf,
                          fileName: 'تقرير_سجلات_النشاط.pdf',
                        );
                      }
                    },
                    onExcelPressed: () async {
                      final bytes = await ActivityLogsExcelBuilder.build(
                        state.report.summary,
                        state.report.items,
                      );
                      if (context.mounted) {
                        await ExcelExportService.saveAndShare(
                          context: context,
                          bytes: bytes,
                          fileName: 'تقرير_سجلات_النشاط.xlsx',
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
        body: BlocBuilder<OwnerActivityLogsCubit, OwnerActivityLogsState>(
          builder: (context, state) {
            if (state is OwnerActivityLogsInitial ||
                (state is OwnerActivityLogsLoading && !state.isPagination)) {
              return const ReportSkeleton();
            }

            if (state is OwnerActivityLogsError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => _cubit.fetchReport(forceRefresh: true),
              );
            }

            if (state is OwnerActivityLogsEmpty) {
              return ReportEmptyWidget(
                message: LocaleKeys.activityLogsNoData.tr(),
                icon: Icons.history_rounded,
              );
            }

            if (state is OwnerActivityLogsLoaded ||
                (state is OwnerActivityLogsLoading && state.isPagination)) {
              final report = state is OwnerActivityLogsLoaded
                  ? state.report
                  : (context.read<OwnerActivityLogsCubit>().state
                            as OwnerActivityLogsLoaded)
                        .report;

              final isLoading =
                  state is OwnerActivityLogsLoading && state.isPagination;

              return RefreshIndicator(
                onRefresh: () async => _cubit.fetchReport(forceRefresh: true),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ActivityLogsSummaryHeader(summary: report.summary),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              LocaleKeys.activityLogsList.tr(),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    ActivityLogsReportList(items: report.items),
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
