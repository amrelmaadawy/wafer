import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/property_details_entity.dart';

class PropertyIncompleteDataCard extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyIncompleteDataCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final missing = <String>[
      if (property.propertyType == null || property.propertyType!.isEmpty)
        LocaleKeys.propertyDetailsPropertyTypeLabel.tr(),
      if (property.branchId == null) LocaleKeys.propertyDetailsBranchLabel.tr(),
      if (property.formattedAddress == null)
        LocaleKeys.propertyDetailsAddressLabel.tr(),
      if (property.deedId == null || property.deedId == 0)
        LocaleKeys.propertyDetailsDeedInfo.tr(),
    ];
    if (!property.isDraft || missing.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.warning),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  LocaleKeys.properties_draft_incomplete.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            LocaleKeys.properties_draft_incomplete_desc.tr(),
            style: const TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: missing
                .map(
                  (label) => Chip(
                    avatar: const Icon(Icons.error_outline, size: 16),
                    label: Text(label),
                    visualDensity: VisualDensity.compact,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
