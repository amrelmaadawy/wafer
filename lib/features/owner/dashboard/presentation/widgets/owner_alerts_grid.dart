import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/theme/app_colors.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../domain/entities/owner_dashboard_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';

class OwnerAlertsGrid extends StatelessWidget {
  final OwnerDashboardEntity data;

  const OwnerAlertsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bolt_rounded, size: 17, color: AppColors.textSecondaryLight),
            const SizedBox(width: 6),
            Text(
              LocaleKeys.ownerQuickAlerts.tr(),
              style: const TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: 140,
                child: _buildCard(
                  title: LocaleKeys.ownerActiveContractsTitle.tr(),
                  count: data.activeContracts,
                  color: AppColors.success,
                  icon: Icons.description_rounded,
                  subtitle: LocaleKeys.ownerActiveContractsSub.tr(),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 140,
                child: _buildCard(
                  title: LocaleKeys.ownerExpiringTitle.tr(),
                  count: data.expiringContracts,
                  color: data.expiringContracts > 0
                      ? AppColors.warning
                      : AppColors.textTertiaryLight,
                  icon: Icons.update_rounded,
                  subtitle: LocaleKeys.ownerExpiringSub.tr(),
                  highlight: data.expiringContracts > 0,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 140,
                child: _buildCard(
                  title: LocaleKeys.ownerPendingMaintTitle.tr(),
                  count: data.pendingMaintenance,
                  color: data.pendingMaintenance > 0
                      ? AppColors.error
                      : AppColors.textTertiaryLight,
                  icon: Icons.handyman_rounded,
                  subtitle: LocaleKeys.ownerPendingMaintSub.tr(),
                  highlight: data.pendingMaintenance > 0,
                  onTap: () {
                    context.push('${Routes.ownerMaintenance}?filter=new');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
    required String subtitle,
    bool highlight = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: highlight ? color.withValues(alpha: 0.06) : Colors.white,
        borderRadius: AppRadius.circularXl,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 5),
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
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: AppRadius.circularMd,
                      ),
                      child: Icon(icon, color: color, size: 14),
                    ),
                    if (highlight)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$count',
                  style: TextStyle(
                    color: highlight ? color : AppColors.textPrimaryLight,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: highlight
                          ? color.withValues(alpha: 0.85)
                          : AppColors.textSecondaryLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textTertiaryLight,
                      fontSize: 10,
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

