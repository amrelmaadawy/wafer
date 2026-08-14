import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/color_utils.dart';
import 'profile_action_tile.dart';

class OperationsCard extends StatelessWidget {
  const OperationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: AppRadius.circularMd,
                  ),
                  child: const Icon(
                    Icons.dashboard_customize_rounded,
                    color: AppColors.info,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  LocaleKeys.dashboard_quick_actions.tr(), // or something similar
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryLight,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderLight),
          ProfileActionTile(
            icon: Icons.admin_panel_settings_rounded,
            label: LocaleKeys.supervisorsList.tr(),
            subtitle: LocaleKeys.supervisorsList.tr(),
            iconBg: context.primaryColor.withValues(alpha: 0.1),
            iconColor: context.primaryColor,
            onTap: () {
              context.push(Routes.ownerSupervisorsList);
            },
          ),
          const Divider(
            height: 1,
            color: AppColors.borderLight,
            indent: 20,
            endIndent: 20,
          ),
          ProfileActionTile(
            icon: Icons.bar_chart_rounded,
            label: LocaleKeys.reports_title.tr(),
            subtitle: LocaleKeys.reports_operational.tr(),
            iconBg: AppColors.info.withValues(alpha: 0.1),
            iconColor: AppColors.info,
            onTap: () {
              context.push(Routes.ownerReportsCenter);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
