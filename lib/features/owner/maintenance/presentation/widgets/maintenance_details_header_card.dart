import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import 'maintenance_status_badge.dart';

class MaintenanceDetailsHeaderCard extends StatelessWidget {
  final MaintenanceItemEntity item;

  const MaintenanceDetailsHeaderCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final locationTitle = item.unit.name.isNotEmpty
        ? '${item.property.name} • ${item.unit.name}'
        : item.property.name.isNotEmpty
            ? item.property.name
            : LocaleKeys.maintenanceNotDeterminedYet.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppRadius.circularXxl,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title.isNotEmpty ? item.title : '#${item.id}',
                      style: TextStyle(
                        color: context.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  MaintenanceStatusBadge(
                    status: item.status,
                    statusLabel: item.statusLabel,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.home_work_outlined,
                      size: 18, color: AppColors.textSecondaryLight),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      locationTitle,
                      style: const TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (item.description.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppRadius.circularXxl,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.commonInfo.tr(),
                  style: TextStyle(
                    color: context.primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
