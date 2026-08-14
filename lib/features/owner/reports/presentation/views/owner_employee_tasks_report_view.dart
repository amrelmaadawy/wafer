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
import '../cubit/owner_employee_tasks_cubit.dart';
import '../cubit/owner_employee_tasks_state.dart';
import '../widgets/employee_tasks_export_actions.dart';
import '../widgets/employee_tasks_page_header.dart';
import '../widgets/employee_tasks_report_list.dart';
import '../widgets/employee_tasks_summary_header.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/report_skeleton.dart';

class OwnerEmployeeTasksReportView extends StatefulWidget {
  const OwnerEmployeeTasksReportView({super.key});

  @override
  State<OwnerEmployeeTasksReportView> createState() =>
      _OwnerEmployeeTasksReportViewState();
}

class _OwnerEmployeeTasksReportViewState
    extends State<OwnerEmployeeTasksReportView> {
  final _scrollController = ScrollController();
  late final OwnerEmployeeTasksCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<OwnerEmployeeTasksCubit>()..fetchReport();
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
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.appBackgroundColor,
        appBar: CustomAppBar(
          title: LocaleKeys.tasksOverviewTitle.tr(),
          actions: const [EmployeeTasksExportActions()],
        ),
        body: BlocBuilder<OwnerEmployeeTasksCubit, OwnerEmployeeTasksState>(
          builder: (context, state) {
            if (state is OwnerEmployeeTasksInitial ||
                (state is OwnerEmployeeTasksLoading && !state.isPagination)) {
              return const AppResponsiveContent(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: ReportSkeleton(),
              );
            }
            if (state is OwnerEmployeeTasksError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => _cubit.fetchReport(forceRefresh: true),
              );
            }
            if (state is OwnerEmployeeTasksEmpty) {
              return RefreshIndicator(
                onRefresh: () => _cubit.fetchReport(forceRefresh: true),
                child: _emptyState(),
              );
            }
            final loaded = state is OwnerEmployeeTasksLoaded ? state : null;
            if (loaded == null) return const SizedBox.shrink();
            return RefreshIndicator(
              onRefresh: () => _cubit.fetchReport(forceRefresh: true),
              child: AppResponsiveContent(child: _loadedState(loaded)),
            );
          },
        ),
      ),
    );
  }

  Widget _loadedState(OwnerEmployeeTasksLoaded state) => ListView(
    controller: _scrollController,
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
    children: [
      const EmployeeTasksPageHeader(),
      const SizedBox(height: AppSpacing.lg),
      EmployeeTasksSummaryHeader(summary: state.report.summary),
      const SizedBox(height: AppSpacing.lg),
      Text(
        LocaleKeys.employeeTasksList.tr(),
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: AppSpacing.sm),
      EmployeeTasksReportList(items: state.report.items),
    ],
  );

  Widget _emptyState() => AppResponsiveContent(
    child: ListView(
      children: [
        const SizedBox(height: AppSpacing.lg),
        const EmployeeTasksPageHeader(),
        SizedBox(
          height: 360,
          child: ReportEmptyWidget(
            message: LocaleKeys.employeeTasksNoData.tr(),
            icon: Icons.assignment_outlined,
          ),
        ),
      ],
    ),
  );
}
