import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/maintenance_item_entity.dart';

class MaintenanceTimelineSection extends StatelessWidget {
  final MaintenanceItemEntity item;

  const MaintenanceTimelineSection({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_rounded,
                  size: 20, color: context.primaryColor),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.maintenanceTimelineSection.tr(),
                style: const TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimelineTile(
            context,
            Icons.date_range_rounded,
            LocaleKeys.maintenanceRequestedDate.tr(),
            item.requestedDate,
            isCompleted: item.requestedDate.isNotEmpty,
            isLast: false,
          ),
          _buildTimelineTile(
            context,
            Icons.schedule_rounded,
            LocaleKeys.maintenanceScheduledDate.tr(),
            item.scheduledDate ?? LocaleKeys.maintenanceUnspecifiedDate.tr(),
            isCompleted:
                item.scheduledDate != null && item.scheduledDate!.isNotEmpty,
            isLast: false,
          ),
          _buildTimelineTile(
            context,
            Icons.check_circle_outline_rounded,
            LocaleKeys.maintenanceCompletedDate.tr(),
            item.completedDate ?? LocaleKeys.maintenanceUnspecifiedDate.tr(),
            isCompleted:
                item.completedDate != null && item.completedDate!.isNotEmpty,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTile(
    BuildContext context,
    IconData icon,
    String title,
    String dateStr, {
    required bool isCompleted,
    required bool isLast,
  }) {
    final iconColor = isCompleted
        ? context.primaryColor
        : AppColors.textSecondaryLight.withValues(alpha: 0.4);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? context.primaryColor.withValues(alpha: 0.12)
                      : AppColors.borderLight.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted
                        ? context.primaryColor.withValues(alpha: 0.3)
                        : AppColors.borderLight,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isCompleted
                          ? AppColors.textPrimaryLight
                          : AppColors.textSecondaryLight,
                      fontSize: 13.5,
                      fontWeight:
                          isCompleted ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    dateStr,
                    style: TextStyle(
                      color: isCompleted
                          ? context.primaryColor
                          : AppColors.textSecondaryLight.withValues(alpha: 0.6),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
