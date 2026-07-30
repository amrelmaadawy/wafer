import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/di/service_locator.dart';
import '../cubit/owner_technician_performance_cubit.dart';
import '../cubit/owner_technician_performance_state.dart';
import '../widgets/technician_performance_summary_header.dart';
import '../widgets/technician_performance_report_list.dart';
import '../widgets/report_skeleton.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/report_export_button.dart';
import '../../../../../core/services/pdf/builders/technician_performance_pdf_builder.dart';
import '../../../../../core/services/excel/builders/technician_performance_excel_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';

class OwnerTechnicianPerformanceReportView extends StatefulWidget {
  const OwnerTechnicianPerformanceReportView({super.key});

  @override
  State<OwnerTechnicianPerformanceReportView> createState() =>
      _OwnerTechnicianPerformanceReportViewState();
}

class _OwnerTechnicianPerformanceReportViewState
    extends State<OwnerTechnicianPerformanceReportView> {
  late final OwnerTechnicianPerformanceCubit _cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = sl<OwnerTechnicianPerformanceCubit>();
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
          title: LocaleKeys.technicianPerformanceTitle.tr(),
          actions: [
            BlocBuilder<
              OwnerTechnicianPerformanceCubit,
              OwnerTechnicianPerformanceState
            >(
              builder: (context, state) {
                if (state is OwnerTechnicianPerformanceLoaded) {
                  return ReportExportButton(
                    onPdfPressed: () async {
                      final pdf = await TechnicianPerformancePdfBuilder.build(
                        state.report.summary,
                        state.report.items,
                      );
                      if (context.mounted) {
                        await PdfGeneratorService.exportAndPrint(
                          context: context,
                          pdf: pdf,
                          fileName: 'تقرير_أداء_الفنيين.pdf',
                        );
                      }
                    },
                    onExcelPressed: () async {
                      final bytes =
                          await TechnicianPerformanceExcelBuilder.build(
                            state.report.summary,
                            state.report.items,
                          );
                      if (context.mounted) {
                        await ExcelExportService.saveAndShare(
                          context: context,
                          bytes: bytes,
                          fileName: 'تقرير_أداء_الفنيين.xlsx',
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
              OwnerTechnicianPerformanceCubit,
              OwnerTechnicianPerformanceState
            >(
              builder: (context, state) {
                if (state is OwnerTechnicianPerformanceInitial ||
                    (state is OwnerTechnicianPerformanceLoading &&
                        !state.isPagination)) {
                  return const ReportSkeleton();
                } else if (state is OwnerTechnicianPerformanceError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () => _cubit.loadReport(refresh: true),
                  );
                } else if (state is OwnerTechnicianPerformanceEmpty) {
                  return ReportEmptyWidget(
                    message: LocaleKeys.technicianPerformanceNoData.tr(),
                    icon: Icons.engineering_outlined,
                  );
                } else if (state is OwnerTechnicianPerformanceLoaded ||
                    (state is OwnerTechnicianPerformanceLoading &&
                        state.isPagination)) {
                  final currentState = _cubit.state;
                  if (currentState is! OwnerTechnicianPerformanceLoaded &&
                      currentState is! OwnerTechnicianPerformanceLoading) {
                    return const SizedBox.shrink();
                  }

                  var report =
                      (currentState is OwnerTechnicianPerformanceLoaded)
                      ? currentState.report
                      : null;

                  if (report == null) return const SizedBox.shrink();

                  return RefreshIndicator(
                    onRefresh: () => _cubit.loadReport(refresh: true),
                    color: AppColors.primary,
                    child: ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        TechnicianPerformanceSummaryHeader(
                          summary: report.summary,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          LocaleKeys.technicianPerformanceList.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TechnicianPerformanceReportList(items: report.items),
                        if (currentState is OwnerTechnicianPerformanceLoading &&
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
