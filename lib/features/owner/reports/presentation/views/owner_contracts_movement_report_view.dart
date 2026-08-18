import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/di/service_locator.dart';
import '../cubit/owner_contracts_movement_cubit.dart';
import '../cubit/owner_contracts_movement_state.dart';
import '../widgets/contracts_movement_summary_header.dart';
import '../widgets/contracts_movement_report_list.dart';
import '../widgets/report_skeleton.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/report_export_button.dart';
import '../../../../../core/services/pdf/builders/contracts_movement_pdf_builder.dart';
import '../../../../../core/services/excel/builders/contracts_movement_excel_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../widgets/filter/universal_reports_filter_bar.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';

class OwnerContractsMovementReportView extends StatefulWidget {
  const OwnerContractsMovementReportView({super.key});

  @override
  State<OwnerContractsMovementReportView> createState() =>
      _OwnerContractsMovementReportViewState();
}

class _OwnerContractsMovementReportViewState
    extends State<OwnerContractsMovementReportView> {
  late final OwnerContractsMovementCubit _cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = sl<OwnerContractsMovementCubit>();
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
          title: LocaleKeys.contractsMovementTitle.tr(),
          actions: [
            BlocBuilder<
              OwnerContractsMovementCubit,
              OwnerContractsMovementState
            >(
              builder: (context, state) {
                if (state is OwnerContractsMovementLoaded) {
                  return ReportExportButton(
                    onPdfPressed: () async {
                      final pdf = await ContractsMovementPdfBuilder.build(
                        state.report.summary,
                        state.report.items,
                      );
                      if (context.mounted) {
                        await PdfGeneratorService.exportAndPrint(
                          context: context,
                          pdf: pdf,
                          fileName: 'تقرير_حركة_العقود.pdf',
                        );
                      }
                    },
                    onExcelPressed: () async {
                      final bytes = await ContractsMovementExcelBuilder.build(
                        state.report.summary,
                        state.report.items,
                      );
                      if (context.mounted) {
                        await ExcelExportService.saveAndShare(
                          context: context,
                          bytes: bytes,
                          fileName: 'تقرير_حركة_العقود.xlsx',
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
              OwnerContractsMovementCubit,
              OwnerContractsMovementState
            >(
              builder: (context, state) {
                if (state is OwnerContractsMovementInitial ||
                    (state is OwnerContractsMovementLoading &&
                        !state.isPagination)) {
                  return const ReportSkeleton();
                } else if (state is OwnerContractsMovementError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () => _cubit.loadReport(refresh: true),
                  );
                } else if (state is OwnerContractsMovementEmpty) {
                  return ReportEmptyWidget(
                    message: LocaleKeys.contractsMovementNoData.tr(),
                    icon: Icons.compare_arrows_rounded,
                  );
                } else if (state is OwnerContractsMovementLoaded ||
                    (state is OwnerContractsMovementLoading &&
                        state.isPagination)) {
                  final currentState = _cubit.state;
                  if (currentState is! OwnerContractsMovementLoaded &&
                      currentState is! OwnerContractsMovementLoading) {
                    return const SizedBox.shrink();
                  }

                  // We need to safely get the report from loaded state
                  var report = (currentState is OwnerContractsMovementLoaded)
                      ? currentState.report
                      : null;

                  if (report == null) return const SizedBox.shrink();

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
                          hasActiveFilters: _cubit.hasActiveFilters,
                          onReset: _cubit.clearFilters,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ContractsMovementSummaryHeader(summary: report.summary),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            LocaleKeys.contractsMovementList.tr(),
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
                          child: ContractsMovementReportList(items: report.items),
                        ),
                        if (currentState is OwnerContractsMovementLoading &&
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
