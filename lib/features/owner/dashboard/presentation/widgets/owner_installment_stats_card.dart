import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../domain/entities/owner_dashboard_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';

class OwnerInstallmentStatsCard extends StatelessWidget {
  final InstallmentStatsEntity stats;

  const OwnerInstallmentStatsCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(Routes.ownerDefaultersReport);
      },
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildStatsRow(),
        ],
      ),
    ));
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: AppRadius.circularMd,
          ),
          child: const Icon(
            Icons.pie_chart_outline,
            color: AppColors.info,
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          LocaleKeys.dashboard_installment_stats.tr(),
          style: const TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                LocaleKeys.dashboard_paid.tr(),
                stats.paid,
                AppColors.success,
                Icons.check_circle_outline_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatItem(
                LocaleKeys.dashboard_unpaid.tr(),
                stats.unpaid,
                AppColors.textSecondaryLight,
                Icons.hourglass_empty_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                LocaleKeys.dashboard_partially_paid.tr(),
                stats.partiallyPaid,
                AppColors.warning,
                Icons.pie_chart_outline_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatItem(
                LocaleKeys.dashboard_overdue.tr(),
                stats.overdue,
                AppColors.error,
                Icons.warning_amber_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

