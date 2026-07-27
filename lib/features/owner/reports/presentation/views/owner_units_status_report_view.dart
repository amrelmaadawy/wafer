import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../cubit/owner_units_status_cubit.dart';
import '../cubit/owner_units_status_state.dart';
import '../widgets/units_status_filter_bar.dart';
import '../widgets/units_status_list_item.dart';
import '../widgets/units_status_skeleton.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/units_status_summary_header.dart';
import '../widgets/report_export_button.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../../../../../core/services/pdf/builders/units_status_pdf_builder.dart';

class OwnerUnitsStatusReportView extends StatefulWidget {
  const OwnerUnitsStatusReportView({super.key});

  @override
  State<OwnerUnitsStatusReportView> createState() =>
      _OwnerUnitsStatusReportViewState();
}

class _OwnerUnitsStatusReportViewState
    extends State<OwnerUnitsStatusReportView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OwnerUnitsStatusCubit>().loadMore();
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
        title: LocaleKeys.reports_unitsStatusReportTitle.tr(),
        actions: [
          BlocBuilder<OwnerUnitsStatusCubit, OwnerUnitsStatusState>(
            builder: (context, state) {
              if (state is OwnerUnitsStatusLoaded) {
                return ReportExportButton(
                  onPdfPressed: () async {
                    final pdf = await UnitsStatusPdfBuilder.build(state.report);
                    if (context.mounted) {
                      await PdfGeneratorService.exportAndPrint(
                        context: context,
                        pdf: pdf,
                        fileName: 'تقرير_حالة_الوحدات.pdf',
                      );
                    }
                  },
                  onExcelPressed: () {
                    // TODO: Implement excel export for units status report
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<OwnerUnitsStatusCubit, OwnerUnitsStatusState>(
        builder: (context, state) {
        if (state is OwnerUnitsStatusInitial ||
            state is OwnerUnitsStatusLoading) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: UnitsStatusSkeleton(),
          );
        }

        if (state is OwnerUnitsStatusError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () => context
                .read<OwnerUnitsStatusCubit>()
                .loadUnitsStatusReport(forceRefresh: true),
          );
        }

        if (state is OwnerUnitsStatusEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              await context
                  .read<OwnerUnitsStatusCubit>()
                  .loadUnitsStatusReport(forceRefresh: true);
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                UnitsStatusFilterBar(filterOptions: state.filterOptions),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ReportEmptyWidget(
                    message: LocaleKeys.reports_empty_state.tr(),
                    icon: Icons.maps_home_work_outlined,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is OwnerUnitsStatusLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              await context
                  .read<OwnerUnitsStatusCubit>()
                  .loadUnitsStatusReport(forceRefresh: true);
            },
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                UnitsStatusFilterBar(
                  filterOptions: state.report.filterOptions,
                ),
                const SizedBox(height: AppSpacing.lg),
                UnitsStatusSummaryHeader(
                  summary: state.report.summary,
                ),
                const SizedBox(height: AppSpacing.xl),
                ...state.report.items.map((item) => UnitsStatusListItem(
                      item: item,
                    )),
                if (!state.hasReachedMax)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                const SizedBox(height: AppSpacing.xxl * 2), // Bottom padding
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    ));
  }
}
