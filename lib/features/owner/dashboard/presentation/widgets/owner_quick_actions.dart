import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../shell/presentation/cubit/owner_nav_cubit.dart';
import '../../../maintenance/presentation/cubit/owner_maintenance_cubit.dart';
import '../../../maintenance/presentation/views/owner_maintenance_view.dart';
import '../../../reports/presentation/screens/owner_reports_center_screen.dart';

class OwnerQuickActions extends StatelessWidget {
  const OwnerQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.grid_view_rounded,
                size: 17, color: Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text(
              LocaleKeys.dashboardQuickActions.tr(),
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
              child: _buildActionCard(
                context,
                title: LocaleKeys.dashboardMaintRequest.tr(),
                icon: Icons.build_circle_outlined,
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider<OwnerMaintenanceCubit>(
                        create: (_) => sl<OwnerMaintenanceCubit>(),
                        child: const OwnerMaintenanceView(),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildActionCard(
                context,
                title: LocaleKeys.dashboardLeaseContract.tr(),
                icon: Icons.description_outlined,
                color: const Color(0xFF10B981),
                onTap: () => context.read<OwnerNavCubit>().changeTab(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildActionCard(
                context,
                title: LocaleKeys.dashboardAddProperty.tr(),
                icon: Icons.apartment_rounded,
                color: context.primaryColor,
                onTap: () => context.read<OwnerNavCubit>().changeTab(1),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildActionCard(
                context,
                title: LocaleKeys.dashboardReports.tr(),
                icon: Icons.bar_chart_rounded,
                color: const Color(0xFFF59E0B),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OwnerReportsCenterScreen(initialTabIndex: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: const Color(0xFFEDF0F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.circularXl,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.circularXl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 34,
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
