import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/properties_stats_entity.dart';

class PropertiesStatsHeaderWidget extends StatelessWidget {
  final PropertiesStatsEntity stats;

  const PropertiesStatsHeaderWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          _buildStatCard(
            context,
            title: LocaleKeys.propertiesStatsTotal.tr(),
            value: '${stats.totalProperties}',
            subtitle: '${LocaleKeys.propertiesStatsBuildings.tr(args: ['${stats.buildingsCount}'])} | ${LocaleKeys.propertiesStatsLands.tr(args: ['${stats.landsCount}'])}',
            icon: Icons.domain_rounded,
            color: context.primaryColor,
            bgColor: context.primarySubtle,
          ),
          const SizedBox(width: 10),
          _buildStatCard(
            context,
            title: LocaleKeys.propertiesStatsUnitsAndDeeds.tr(),
            value: '${stats.totalUnits}',
            subtitle: LocaleKeys.propertiesStatsDeeds.tr(args: ['${stats.totalDeeds}']),
            icon: Icons.grid_view_rounded,
            color: const Color(0xFF0EA5E9),
            bgColor: const Color(0xFFE0F2FE),
          ),
          const SizedBox(width: 10),
          _buildStatCard(
            context,
            title: LocaleKeys.propertiesStatsUsages.tr(),
            value: '${stats.residentialCount + stats.commercialCount + stats.mixedCount}',
            subtitle: '${LocaleKeys.propertiesStatsResidential.tr(args: ['${stats.residentialCount}'])} | ${LocaleKeys.propertiesStatsMixed.tr(args: ['${stats.mixedCount}'])}',
            icon: Icons.pie_chart_rounded,
            color: const Color(0xFF10B981),
            bgColor: const Color(0xFFD1FAE5),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: AppRadius.circularMd,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
