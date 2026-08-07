import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/owner_contracts_report_cubit.dart';
import '../cubit/owner_contracts_report_state.dart';
import '../widgets/contracts_report_list.dart';
import '../widgets/report_skeleton.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/contracts_summary_header.dart';
import '../widgets/report_export_button.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../../../../../core/services/pdf/builders/contracts_pdf_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../../../../../core/services/excel/builders/contracts_excel_builder.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';

class OwnerContractsReportView extends StatefulWidget {
  const OwnerContractsReportView({super.key});

  @override
  State<OwnerContractsReportView> createState() =>
      _OwnerContractsReportViewState();
}

class _OwnerContractsReportViewState extends State<OwnerContractsReportView> {
  final ScrollController _scrollController = ScrollController();

  int? _selectedPropertyId;
  String? _selectedStatus;

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
              context.read<OwnerContractsReportCubit>().state
                  is! OwnerContractsReportLoaded) {
            return const ReportSkeleton();
          } else if (state is OwnerContractsReportError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context
                  .read<OwnerContractsReportCubit>()
                  .loadContractsReport(forceRefresh: true),
            );
          } else if (state is OwnerContractsReportEmpty) {
            return ReportEmptyWidget(
              message: LocaleKeys.reports_empty_state.tr(),
              icon: Icons.description_outlined,
            );
          } else if (state is OwnerContractsReportLoaded) {
            return RefreshIndicator(
              color: context.primaryColor,
              onRefresh: () => context
                  .read<OwnerContractsReportCubit>()
                  .loadContractsReport(forceRefresh: true),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20).copyWith(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ContractsSummaryHeader(
                      total: state.report.summary.total,
                      active: state.report.summary.active,
                      expired: state.report.summary.expired,
                      expiringNext30Days: state.report.summary.expiringNext30Days,
                      totalRentValue: state.report.summary.totalRentValue,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdownMenu<String>(
                            value: _selectedStatus,
                            items: [
                              'all',
                              ...state.report.filterOptions.statuses.map((e) => e.value),
                            ],
                            itemLabelBuilder: (val) {
                              if (val == 'all') return LocaleKeys.reports_all.tr();
                              final match = state.report.filterOptions.statuses
                                  .where((e) => e.value == val).toList();
                              return match.isNotEmpty ? match.first.label : val;
                            },
                            hint: LocaleKeys.reports_status.tr(),
                            onSelected: (val) {
                              final newStatus = val == 'all' ? null : val;
                              if (_selectedStatus != newStatus) {
                                setState(() {
                                  _selectedStatus = newStatus;
                                });
                                context.read<OwnerContractsReportCubit>().loadContractsReport(
                                  forceRefresh: true,
                                  status: newStatus,
                                  propertyId: _selectedPropertyId,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomDropdownMenu<int>(
                            value: _selectedPropertyId,
                            items: [
                              -1,
                              ...state.report.filterOptions.properties.map((e) => e.id),
                            ],
                            itemLabelBuilder: (val) {
                              if (val == -1) return LocaleKeys.reports_allProperties.tr();
                              final match = state.report.filterOptions.properties
                                  .where((e) => e.id == val).toList();
                              return match.isNotEmpty ? (match.first.name ?? match.first.code) : val.toString();
                            },
                            hint: LocaleKeys.property.tr(),
                            onSelected: (val) {
                              final newProp = val == -1 ? null : val;
                              if (_selectedPropertyId != newProp) {
                                setState(() {
                                  _selectedPropertyId = newProp;
                                });
                                context.read<OwnerContractsReportCubit>().loadContractsReport(
                                  forceRefresh: true,
                                  propertyId: newProp,
                                  status: _selectedStatus,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    ContractsReportList(contracts: state.report.items),
                    if (!state.hasReachedMax)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      ),
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
