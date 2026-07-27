import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/routing/routes.dart';

class OwnerReportsCenterScreen extends StatelessWidget {
  const OwnerReportsCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: LocaleKeys.dashboardReports.tr(),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildCategorySection(
              context,
              title: LocaleKeys.financial.tr(),
              reports: [
                _ReportItem(
                  title: LocaleKeys.revenueReport.tr(),
                  subtitle: 'عرض إيرادات العقارات والوحدات بالتفصيل',
                  icon: Icons.attach_money_rounded,
                  route: Routes.ownerRevenueReport,
                ),
                _ReportItem(
                  title: LocaleKeys.defaultersReportTitle.tr(),
                  subtitle: 'متابعة المتأخرات والمدفوعات المستحقة',
                  icon: Icons.warning_amber_rounded,
                  route: Routes.ownerDefaultersReport,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCategorySection(
              context,
              title: LocaleKeys.operational.tr(),
              reports: [
                _ReportItem(
                  title: LocaleKeys.occupancyReportTitle.tr(),
                  subtitle: 'تحليل ومتابعة نسب الإشغال والشاغر',
                  icon: Icons.pie_chart_rounded,
                  route: Routes.ownerOccupancyReport,
                ),
                _ReportItem(
                  title: LocaleKeys.reports_unitsStatusReportTitle.tr(),
                  subtitle: 'نظرة عامة وحالة جميع الوحدات العقارية',
                  icon: Icons.maps_home_work_rounded,
                  route: Routes.ownerUnitsStatusReport,
                ),
                _ReportItem(
                  title: LocaleKeys.maintenanceRequestsTitle.tr(),
                  subtitle: 'متابعة وإدارة طلبات الصيانة',
                  icon: Icons.build_circle_outlined,
                  route: Routes.ownerMaintenanceRequestsReport,
                ),
                _ReportItem(
                  title: LocaleKeys.technicianPerformanceTitle.tr(),
                  subtitle: 'متابعة أداء الفنيين وإنجازاتهم',
                  icon: Icons.engineering_outlined,
                  route: Routes.ownerTechnicianPerformanceReport,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCategorySection(
              context,
              title: LocaleKeys.reports_contracts.tr(),
              reports: [
                _ReportItem(
                  title: LocaleKeys.reports_contracts.tr(),
                  subtitle: 'عرض وتتبع حالة جميع العقود الإيجارية',
                  icon: Icons.description_outlined,
                  route: Routes.ownerContractsReport,
                ),
                _ReportItem(
                  title: LocaleKeys.contractsMovementTitle.tr(),
                  subtitle: 'تتبع حركات إنشاء وتجديد وإلغاء العقود',
                  icon: Icons.sync_alt_rounded,
                  route: Routes.ownerContractsMovementReport,
                ),
              ],
            ),
          ),
          // Additional categories (System Activity) can be added here
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context,
      {required String title, required List<_ReportItem> reports}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              title,
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
            itemCount: reports.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _ReportCard(item: reports[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _ReportItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  _ReportItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });
}

class _ReportCard extends StatelessWidget {
  final _ReportItem item;

  const _ReportCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: AppRadius.circularXl,
      shadowColor: context.primaryShadow.withValues(alpha: 0.04),
      elevation: 2,
      child: InkWell(
        onTap: () {
          context.push(item.route);
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
                child: Icon(item.icon, color: context.primaryColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimaryLight,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondaryLight,
                        height: 1.3,
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
}
