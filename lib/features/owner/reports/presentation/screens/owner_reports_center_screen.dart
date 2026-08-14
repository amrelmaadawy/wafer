import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/di/service_locator.dart';
import '../../domain/entities/owner_reports_index_entity.dart';
import '../cubit/owner_reports_index_cubit.dart';
import '../cubit/owner_reports_index_state.dart';
import '../widgets/reports_index_skeleton.dart';

class OwnerReportsCenterScreen extends StatelessWidget {
  const OwnerReportsCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OwnerReportsIndexCubit>()..fetchReportsIndex(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: CustomAppBar(title: LocaleKeys.dashboardReports.tr()),
        body: BlocBuilder<OwnerReportsIndexCubit, OwnerReportsIndexState>(
          builder: (context, state) {
            if (state is OwnerReportsIndexLoading ||
                state is OwnerReportsIndexInitial) {
              return const ReportsIndexSkeleton();
            } else if (state is OwnerReportsIndexError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () =>
                    context.read<OwnerReportsIndexCubit>().fetchReportsIndex(),
              );
            } else if (state is OwnerReportsIndexLoaded) {
              return _buildSuccessState(context, state.indexData);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSuccessState(
    BuildContext context,
    OwnerReportsIndexEntity data,
  ) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildStatsSection(context, data.stats)),
        SliverToBoxAdapter(
          child: _buildDynamicReportsSection(context, data.reports),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, ReportStatsEntity stats) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              LocaleKeys.reports_overview.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              _buildStatCard(
                context,
                title: LocaleKeys.reports_totalProperties.tr(),
                value: stats.totalProperties.toString(),
                icon: Icons.apartment_rounded,
              ),
              _buildStatCard(
                context,
                title: LocaleKeys.reports_totalUnits.tr(),
                value: stats.totalUnits.toString(),
                icon: Icons.maps_home_work_rounded,
              ),
              _buildStatCard(
                context,
                title: LocaleKeys.reports_activeContracts.tr(),
                value: stats.activeContracts.toString(),
                icon: Icons.description_outlined,
              ),
              _buildStatCard(
                context,
                title: LocaleKeys.reports_openMaintenance.tr(),
                value: stats.openMaintenance.toString(),
                icon: Icons.build_circle_outlined,
                isWarning: stats.openMaintenance > 0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    bool isWarning = false,
  }) {
    final color = isWarning ? Colors.orange : context.primaryColor;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicReportsSection(
    BuildContext context,
    List<ReportMetaEntity> apiReports,
  ) {
    if (apiReports.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            LocaleKeys.reports_empty_state.tr(),
            style: const TextStyle(color: AppColors.textSecondaryLight),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              LocaleKeys.reports_available.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: apiReports.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final report = apiReports[index];
              return _ReportCard(
                report: report,
                route: _getRouteForKey(report.key),
                icon: _getIconForKey(report.key),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getRouteForKey(String key) {
    switch (key) {
      case 'revenue':
        return Routes.ownerRevenueReport;
      case 'defaulters':
        return Routes.ownerDefaultersReport;
      case 'occupancy':
        return Routes.ownerOccupancyReport;
      case 'units_status':
        return Routes.ownerUnitsStatusReport;
      case 'maintenance_requests':
        return Routes.ownerMaintenanceRequestsReport;
      case 'technician_performance':
        return Routes.ownerTechnicianPerformanceReport;
      case 'employee_tasks':
        return Routes.ownerEmployeeTasksReport;
      case 'activity_logs':
        return Routes.ownerActivityLogsReport;
      case 'approvals':
        return Routes.ownerReportsApprovals;
      case 'legal_cases':
        return Routes.ownerReportsLegalCases;
      case 'contracts':
        return Routes.ownerContractsReport;
      case 'contracts_movement':
        return Routes.ownerContractsMovementReport;
      default:
        return '';
    }
  }

  IconData _getIconForKey(String key) {
    switch (key) {
      case 'revenue':
        return Icons.attach_money_rounded;
      case 'defaulters':
        return Icons.warning_amber_rounded;
      case 'occupancy':
        return Icons.pie_chart_rounded;
      case 'units_status':
        return Icons.maps_home_work_rounded;
      case 'maintenance_requests':
        return Icons.build_circle_outlined;
      case 'technician_performance':
        return Icons.engineering_outlined;
      case 'employee_tasks':
        return Icons.assignment_ind_outlined;
      case 'activity_logs':
        return Icons.history_rounded;
      case 'approvals':
        return Icons.checklist_rtl_rounded;
      case 'legal_cases':
        return Icons.gavel_rounded;
      case 'contracts':
        return Icons.description_outlined;
      case 'contracts_movement':
        return Icons.sync_alt_rounded;
      default:
        return Icons.insert_chart_outlined_rounded;
    }
  }
}

class _ReportCard extends StatelessWidget {
  final ReportMetaEntity report;
  final String route;
  final IconData icon;

  const _ReportCard({
    required this.report,
    required this.route,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (route.isEmpty) return const SizedBox.shrink(); // Hide unmapped reports

    return Material(
      color: Colors.white,
      borderRadius: AppRadius.circularXl,
      shadowColor: context.primaryShadow.withValues(alpha: 0.04),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Future UX enhancement: we could pass the global filter_options to the route here
          // context.push(route, extra: filterOptions);
          context.push(route);
        },
        borderRadius: AppRadius.circularXl,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: AppRadius.circularXl,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.08),
                  borderRadius: AppRadius.circularLg,
                ),
                child: Icon(icon, color: context.primaryColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getLocalizedReportName(report.key, report.name),
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimaryLight,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.chevron_left_rounded,
                size: 24,
                color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedReportName(String key, String fallbackName) {
    switch (key) {
      case 'revenue':
        return 'الإيرادات';
      case 'defaulters':
        return 'المتعثرين';
      case 'occupancy':
        return 'نسب الإشغال';
      case 'units_status':
        return 'حالة الوحدات';
      case 'maintenance_requests':
        return 'طلبات الصيانة';
      case 'technician_performance':
        return 'أداء الفنيين';
      case 'employee_tasks':
        return 'مهام الموظفين';
      case 'activity_logs':
        return 'سجل النشاط';
      case 'approvals':
        return 'الاعتمادات';
      case 'legal_cases':
        return 'القضايا القانونية';
      case 'contracts':
        return 'العقود';
      case 'contracts_movement':
        return 'حركة العقود';
      default:
        return fallbackName;
    }
  }
}
