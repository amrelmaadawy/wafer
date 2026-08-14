import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/activity_logs_report_entity.dart';
import '../cubit/owner_activity_logs_cubit.dart';
import '../cubit/owner_activity_logs_state.dart';
import '../widgets/activity_logs_export_actions.dart';
import '../widgets/activity_logs_filter_bar.dart';
import '../widgets/activity_logs_page_header.dart';
import '../widgets/activity_logs_report_list.dart';
import '../widgets/activity_logs_summary_header.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/report_skeleton.dart';

class OwnerActivityLogsReportView extends StatefulWidget {
  const OwnerActivityLogsReportView({super.key});

  @override
  State<OwnerActivityLogsReportView> createState() =>
      _OwnerActivityLogsReportViewState();
}

class _OwnerActivityLogsReportViewState
    extends State<OwnerActivityLogsReportView> {
  final _scrollController = ScrollController();
  late final OwnerActivityLogsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<OwnerActivityLogsCubit>()..fetchReport();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 280) _cubit.fetchReport();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _cubit,
    child: Scaffold(
      backgroundColor: context.appBackgroundColor,
      appBar: CustomAppBar(
        title: LocaleKeys.activityLogsTitle.tr(),
        actions: const [ActivityLogsExportActions()],
      ),
      body: BlocBuilder<OwnerActivityLogsCubit, OwnerActivityLogsState>(
        builder: (context, state) {
          if (state is OwnerActivityLogsInitial ||
              (state is OwnerActivityLogsLoading && !state.isPagination)) {
            return const AppResponsiveContent(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: ReportSkeleton(),
            );
          }
          if (state is OwnerActivityLogsError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => _cubit.fetchReport(forceRefresh: true),
            );
          }
          final report = switch (state) {
            OwnerActivityLogsLoaded(:final report) => report,
            OwnerActivityLogsLoading(:final report) => report,
            OwnerActivityLogsEmpty(:final report) => report,
            _ => null,
          };
          if (report == null) return const SizedBox.shrink();
          return RefreshIndicator(
            onRefresh: () => _cubit.fetchReport(forceRefresh: true),
            child: AppResponsiveContent(
              child: _ActivityLogsContent(
                report: report,
                controller: _scrollController,
                isPaginating:
                    state is OwnerActivityLogsLoading && state.isPagination,
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _ActivityLogsContent extends StatelessWidget {
  const _ActivityLogsContent({
    required this.report,
    required this.controller,
    required this.isPaginating,
  });

  final ActivityLogsReportEntity report;
  final ScrollController controller;
  final bool isPaginating;

  @override
  Widget build(BuildContext context) => ListView(
    controller: controller,
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
    children: [
      const ActivityLogsPageHeader(),
      const SizedBox(height: AppSpacing.sm),
      ActivityLogsSummaryHeader(summary: report.summary),
      const SizedBox(height: AppSpacing.sm),
      ActivityLogsFilterBar(types: report.types, actions: report.actions),
      const SizedBox(height: AppSpacing.lg),
      Text(
        LocaleKeys.activityLogsResults.tr(
          args: [report.pagination.total.toString()],
        ),
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: AppSpacing.sm),
      if (report.items.isEmpty)
        SizedBox(
          height: 320,
          child: ReportEmptyWidget(
            message: LocaleKeys.activityLogsNoData.tr(),
            icon: Icons.history_rounded,
          ),
        )
      else
        ActivityLogsReportList(items: report.items),
      if (isPaginating)
        const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Center(child: CircularProgressIndicator()),
        ),
    ],
  );
}
