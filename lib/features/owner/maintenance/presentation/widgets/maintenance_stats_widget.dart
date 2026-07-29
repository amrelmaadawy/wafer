import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/maintenance_sub_entities.dart';

class MaintenanceStatsWidget extends StatelessWidget {
  final MaintenanceStatsEntity stats;
  final String activeStatus;
  final Function(String) onStatusSelected;

  const MaintenanceStatsWidget({
    super.key,
    required this.stats,
    required this.activeStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _buildChip(
            context,
            label: LocaleKeys.maintenanceFilterAll.tr(),
            count: stats.total ?? 0,
            status: 'all',
          ),
          _buildChip(
            context,
            label: LocaleKeys.maintenanceStatusPending.tr(),
            count: stats.byStatus?['new'] ?? 0,
            status: 'new',
          ),
          _buildChip(
            context,
            label: LocaleKeys.maintenanceStatusInProgress.tr(),
            count: stats.byStatus?['assigned'] ?? 0,
            status: 'assigned',
          ),
          _buildChip(
            context,
            label: LocaleKeys.maintenanceStatusExecuted.tr(),
            count: stats.byStatus?['executed'] ?? 0,
            status: 'executed',
          ),
          _buildChip(
            context,
            label: LocaleKeys.maintenanceStatusCancelled.tr(),
            count: stats.byStatus?['cancelled'] ?? 0,
            status: 'cancelled',
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required int count,
    required String status,
  }) {
    final isSelected = activeStatus == status;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimaryLight,
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : AppColors.backgroundLight,
                borderRadius: AppRadius.circularSm,
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color:
                      isSelected ? Colors.white : AppColors.textSecondaryLight,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onStatusSelected(status),
        backgroundColor: AppColors.surfaceLight,
        selectedColor: context.primaryColor,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.circularFull,
          side: BorderSide(
            color: isSelected ? context.primaryColor : AppColors.borderLight,
          ),
        ),
      ),
    );
  }
}
