import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';


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
              LocaleKeys.dashboard_quick_actions.tr(),
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: LocaleKeys.dashboard_lease_contract.tr(),
                      icon: Icons.description_outlined,
                      color: const Color(0xFF10B981),
                      onTap: () => context.go(Routes.ownerContracts),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: LocaleKeys.dashboard_add_property.tr(),
                      icon: Icons.apartment_rounded,
                      color: context.primaryColor,
                      onTap: () => context.push(Routes.ownerPropertyCreate),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: LocaleKeys.maintenance_title.tr(),
                      icon: Icons.build_circle_outlined,
                      color: const Color(0xFFEF4444),
                      onTap: () {
                        context.push(Routes.ownerMaintenance);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: LocaleKeys.dashboard_reports.tr(),
                      icon: Icons.bar_chart_rounded,
                      color: const Color(0xFFF59E0B),
                      onTap: () {
                        context.push('${Routes.ownerReportsCenter}?tab=0');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: LocaleKeys.deeds_title.tr(),
                      icon: Icons.file_present_rounded,
                      color: const Color(0xFF8B5CF6), // Purple
                      onTap: () {
                        context.push(Routes.ownerDeeds);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
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
