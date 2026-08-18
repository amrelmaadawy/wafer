import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/services/excel/builders/contracts_excel_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../../../../../core/services/pdf/builders/contracts_pdf_builder.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/owner_contracts_report_cubit.dart';
import '../cubit/owner_contracts_report_state.dart';
import '../widgets/contracts_report_list.dart';
import '../widgets/contracts_summary_header.dart';
import '../widgets/filter/report_property_chip.dart';
import '../widgets/filter/report_status_chip.dart';
import '../widgets/filter/universal_reports_filter_bar.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/report_export_button.dart';
import '../widgets/report_skeleton.dart';

class OwnerContractsReportView extends StatefulWidget {
  const OwnerContractsReportView({super.key});

  @override
  State<OwnerContractsReportView> createState() =>
      _OwnerContractsReportViewState();
}

class _OwnerContractsReportViewState extends State<OwnerContractsReportView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<OwnerContractsReportCubit>().loadContractsReport();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OwnerContractsReportCubit>().loadContractsReport();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OwnerContractsReportCubit>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: LocaleKeys.reports_contracts.tr(),
        actions: [
          BlocBuilder<OwnerContractsReportCubit, OwnerContractsReportState>(
            builder: (context, state) {
              if (state is OwnerContractsReportLoaded) {
                return ReportExportButton(
                  onPdfPressed: () async {
                    final pdf = await ContractsPdfBuilder.build(
                      state.report.items,
                      state.report.summary.total,
                      state.report.summary.totalRentValue,
                      state.report.summary.expiringNext30Days,
                    );
                    if (context.mounted) {
                      await PdfGeneratorService.exportAndPrint(
                        context: context,
                        pdf: pdf,
                        fileName: 'تقرير_العقود.pdf',
                      );
                    }
                  },
                  onExcelPressed: () async {
                    final bytes = await ContractsExcelBuilder.build(
                      state.report.items,
                      state.report.summary.total,
                      state.report.summary.totalRentValue,
                      state.report.summary.expiringNext30Days,
                    );
                    if (context.mounted) {
                      await ExcelExportService.saveAndShare(
                        context: context,
                        bytes: bytes,
                        fileName: 'تقرير_العقود.xlsx',
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
      body: BlocBuilder<OwnerContractsReportCubit, OwnerContractsReportState>(
        builder: (context, state) {
          if (state is OwnerContractsReportLoading &&
              cubit.state is! OwnerContractsReportLoaded) {
            return const ReportSkeleton();
          } else if (state is OwnerContractsReportError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => cubit.loadContractsReport(forceRefresh: true),
            );
          } else if (state is OwnerContractsReportLoaded) {
            final propertyItems = state.report.filterOptions.properties
                .map((p) => ReportPropertyItem(
                      id: p.id,
                      displayName: p.name ?? p.code,
                      code: p.code,
                    ))
                .toList();

            final statusItems = state.report.filterOptions.statuses
                .map((s) => ReportStatusItem(value: s.value, label: s.label))
                .toList();

            return RefreshIndicator(
              color: context.primaryColor,
              onRefresh: () => cubit.loadContractsReport(forceRefresh: true),
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
                        cubit.loadContractsReport(
                          forceRefresh: true,
                          startDate: start,
                          endDate: end,
                        );
                      },
                      showProperty: propertyItems.isNotEmpty,
                      selectedPropertyId: cubit.selectedPropertyId,
                      properties: propertyItems,
                      onPropertySelected: (propId) {
                        cubit.loadContractsReport(
                          forceRefresh: true,
                          propertyId: propId,
                        );
                      },
                      showStatus: statusItems.isNotEmpty,
                      selectedStatus: cubit.selectedStatus,
                      statuses: statusItems,
                      onStatusSelected: (status) {
                        cubit.loadContractsReport(
                          forceRefresh: true,
                          status: status,
                        );
                      },
                      hasActiveFilters: cubit.hasActiveFilters,
                      onReset: cubit.clearFilters,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ContractsSummaryHeader(
                        total: state.report.summary.total,
                        active: state.report.summary.active,
                        expired: state.report.summary.expired,
                        expiringNext30Days:
                            state.report.summary.expiringNext30Days,
                        totalRentValue: state.report.summary.totalRentValue,
                      ),
                    ),
                    const SizedBox(height: 22),
                    if (state.report.items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: ReportEmptyWidget(
                          message: LocaleKeys.reports_empty_state.tr(),
                          icon: Icons.description_outlined,
                        ),
                      )
                    else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ContractsReportList(contracts: state.report.items),
                      ),
                      if (!state.hasReachedMax)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
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
}
