import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/app_colors.dart';

class OwnerQuickActions extends StatelessWidget {
  const OwnerQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.grid_view_rounded,
              size: 17,
              color: Color(0xFF64748B),
            ),
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
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: 130,
                child: _buildActionCard(
                  context,
                  title: LocaleKeys.maintenance_title.tr(),
                  icon: Icons.build_circle_outlined,
                  color: AppColors.error,
                  onTap: () {
                    context.push(Routes.ownerMaintenance);
                  },
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 130,
                child: _buildActionCard(
                  context,
                  title: LocaleKeys.dashboard_reports.tr(),
                  icon: Icons.bar_chart_rounded,
                  color: AppColors.warning,
                  onTap: () {
                    context.push('${Routes.ownerReportsCenter}?tab=0');
                  },
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 130,
                child: _buildActionCard(
                  context,
                  title: LocaleKeys.legal_cases.tr(),
                  icon: Icons.gavel_rounded,
                  color: const Color(0xFF8B5CF6),
                  onTap: () {
                    context.push(Routes.ownerLegalCases);
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
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXl,
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow.withValues(alpha: 0.03),
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
                        color: AppColors.textPrimaryLight,
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
