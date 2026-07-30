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

  static const List<String> _statuses = [
    'all',
    'new',
    'pending_supervisor',
    'approved',
    'assigned',
    'in_progress',
    'executed',
    'pending_closure',
    'closed',
    'forwarded',
    'rejected',
    'cancelled',
  ];

  String _getLabel(String status) {
    switch (status) {
      case 'all':
        return LocaleKeys.maintenanceFilterAll.tr();
      case 'new':
        return LocaleKeys.maintenanceStatusPending.tr();
      case 'pending_supervisor':
        return LocaleKeys.maintenanceStatusPendingSupervisor.tr();
      case 'approved':
        return LocaleKeys.maintenanceStatusApproved.tr();
      case 'assigned':
        return LocaleKeys.maintenanceStatusAssigned.tr();
      case 'in_progress':
        return LocaleKeys.maintenanceStatusInProgress.tr();
      case 'executed':
        return LocaleKeys.maintenanceStatusExecuted.tr();
      case 'pending_closure':
        return LocaleKeys.maintenanceStatusPendingClosure.tr();
      case 'closed':
        return LocaleKeys.maintenanceStatusClosed.tr();
      case 'forwarded':
        return LocaleKeys.maintenanceStatusForwarded.tr();
      case 'rejected':
        return LocaleKeys.maintenanceStatusRejected.tr();
      case 'cancelled':
        return LocaleKeys.maintenanceStatusCancelled.tr();
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: _statuses.map((status) {
          final count = status == 'all'
              ? (stats.total ?? 0)
              : (stats.byStatus?[status] ?? 0);
          return _buildChip(
            context,
            label: _getLabel(status),
            count: count,
            status: status,
          );
        }).toList(),
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
                  color: isSelected
                      ? Colors.white
                      : AppColors.textSecondaryLight,
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
