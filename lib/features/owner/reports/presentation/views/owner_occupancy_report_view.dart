import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../cubit/owner_occupancy_cubit.dart';
import '../cubit/owner_occupancy_state.dart';
import '../widgets/occupancy_properties_list.dart';
import '../widgets/occupancy_skeleton.dart';
import '../widgets/occupancy_summary_header.dart';
import '../widgets/report_export_button.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../../../../../core/services/pdf/builders/occupancy_pdf_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../../../../../core/services/excel/builders/occupancy_excel_builder.dart';

class OwnerOccupancyReportView extends StatefulWidget {
  const OwnerOccupancyReportView({super.key});

  @override
  State<OwnerOccupancyReportView> createState() => _OwnerOccupancyReportViewState();
}

class _OwnerOccupancyReportViewState extends State<OwnerOccupancyReportView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OwnerOccupancyCubit>().loadOccupancyReport();
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
        title: LocaleKeys.occupancyReportTitle.tr(),
        actions: [
          BlocBuilder<OwnerOccupancyCubit, OwnerOccupancyState>(
            builder: (context, state) {
              if (state is OwnerOccupancyLoaded) {
                return ReportExportButton(
                  onPdfPressed: () async {
                    final pdf = await OccupancyPdfBuilder.build(
                      state.report.items,
                      state.report.summary.overallOccupancy,
                      state.report.summary.totalUnits,
                      state.report.summary.rentedUnits,
                      state.report.summary.totalUnits - state.report.summary.rentedUnits,
                    );
                    if (context.mounted) {
                      await PdfGeneratorService.exportAndPrint(
                        context: context,
                        pdf: pdf,
                        fileName: 'تقرير_الإشغال.pdf',
                      );
                    }
                  },
                  onExcelPressed: () async {
                    final bytes = await OccupancyExcelBuilder.build(
                      state.report.items,
                      state.report.summary.overallOccupancy,
                      state.report.summary.totalUnits,
                      state.report.summary.rentedUnits,
                      state.report.summary.totalUnits - state.report.summary.rentedUnits,
                    );
                    if (context.mounted) {
                      await ExcelExportService.saveAndShare(
                        context: context,
                        bytes: bytes,
                        fileName: 'تقرير_الإشغال.xlsx',
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
      body: BlocBuilder<OwnerOccupancyCubit, OwnerOccupancyState>(
        builder: (context, state) {
        if (state is OwnerOccupancyLoading && context.read<OwnerOccupancyCubit>().state is! OwnerOccupancyLoaded) {
          return const SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: OccupancySkeleton(),
          );
        } else if (state is OwnerOccupancyError) {
          return _buildErrorView(context, state.message);
        } else if (state is OwnerOccupancyEmpty) {
          return _buildEmptyView(context);
        } else if (state is OwnerOccupancyLoaded) {
          return RefreshIndicator(
            color: context.primaryColor,
            onRefresh: () => context
                .read<OwnerOccupancyCubit>()
                .loadOccupancyReport(forceRefresh: true),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OccupancySummaryHeader(
                    overallRate: state.report.summary.overallOccupancy,
                    totalUnits: state.report.summary.totalUnits,
                    totalRented: state.report.summary.rentedUnits,
                    totalVacant: state.report.summary.totalUnits - state.report.summary.rentedUnits,
                  ),
                  const SizedBox(height: 22),
                  OccupancyPropertiesList(properties: state.report.items),
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
    ));
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return CustomErrorWidget(
      message: message,
      onRetry: () => context
          .read<OwnerOccupancyCubit>()
          .loadOccupancyReport(forceRefresh: true),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.domain_disabled_rounded,
              size: 56, color: AppColors.textSecondaryLight),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.occupancyNoData.tr(),
            style: const TextStyle(
                color: AppColors.textSecondaryLight, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
