import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../domain/entities/technician_entity.dart';

class TechnicianCard extends StatelessWidget {
  final TechnicianEntity technician;

  const TechnicianCard({
    super.key,
    required this.technician,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.circularMd,
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  technician.name,
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildStatusBadge(context),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Specialty and Phone
          if (technician.specialty != null || technician.phone != null)
            Row(
              children: [
                if (technician.specialty != null)
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.engineering_outlined,
                          size: 16,
                          color: context.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            technician.specialty!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (technician.phone != null)
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 16,
                          color: context.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            technician.phone!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: AppSpacing.md),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                title: LocaleKeys.activeAssignments.tr(),
                value: technician.stats.activeOwnerAssignmentsCount.toString(),
                icon: Icons.assignment_ind_outlined,
                color: AppColors.warning,
              ),
              _buildStatItem(
                context,
                title: LocaleKeys.totalAssignments.tr(),
                value: technician.stats.ownerAssignmentsCount.toString(),
                icon: Icons.assignment_outlined,
                color: context.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final color = technician.isActive ? AppColors.success : AppColors.error;
    final text = technician.isActive
        ? LocaleKeys.active.tr()
        : LocaleKeys.inactive.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularSm,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
