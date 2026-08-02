import 'package:flutter/material.dart';
import '../../domain/entities/legal_case_item_entity.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import 'package:easy_localization/easy_localization.dart';

class LegalCaseCardWidget extends StatelessWidget {
  final LegalCaseItemEntity legalCase;
  final VoidCallback onTap;
  final VoidCallback? onEditTap;

  const LegalCaseCardWidget({
    super.key,
    required this.legalCase,
    required this.onTap,
    this.onEditTap,
  });

  Color _getStatusColor(String? colorCode, BuildContext context) {
    if (colorCode == null) return AppColors.primaryDark;
    switch (colorCode) {
      case 'primary':
        return context.primaryColor;
      case 'success':
        return AppColors.success;
      case 'danger':
        return AppColors.error;
      case 'warning':
        return AppColors.warning;
      case 'info':
        return AppColors.info;
      case 'dark':
        return AppColors.primaryDark;
      case 'light':
        return AppColors.surfaceLight;
      default:
        return AppColors.primaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(legalCase.statusColor, context);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circularXl,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.circularXl,
          boxShadow: [
            BoxShadow(
              color: context.primaryShadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    legalCase.caseNumber ?? '',
                    style: AppTextStyles.h4,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: AppRadius.circularMd,
                      ),
                      child: Text(
                        legalCase.status ?? '',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: statusColor,
                          fontWeight: AppFonts.bold,
                        ),
                      ),
                    ),
                    if (onEditTap != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      InkWell(
                        onTap: onEditTap,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit, size: 16, color: context.primaryColor),
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            
            // Court and Type
            Row(
              children: [
                const Icon(Icons.account_balance,
                    size: 16, color: AppColors.textSecondaryLight),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${legalCase.court ?? ''} - ${legalCase.caseType ?? ''}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Latest Stage
            if (legalCase.latestStage != null)
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: AppRadius.circularMd,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timeline, // You might map bx-icons here
                      size: 16,
                      color: _getStatusColor(
                          legalCase.latestStage?.stageColor, context),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        legalCase.latestStage?.stageNameDisplay ?? '',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: AppFonts.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (legalCase.latestStage?.stageDate != null)
                      Text(
                        legalCase.latestStage!.stageDate!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: AppSpacing.sm),
            const Divider(color: AppColors.borderLight, height: 1),
            const SizedBox(height: AppSpacing.sm),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (legalCase.amount != null && legalCase.amount! > 0)
                  Row(
                    children: [
                      const Icon(Icons.monetization_on_outlined,
                          size: 16, color: AppColors.primaryDark),
                      const SizedBox(width: 4),
                      Text(
                        '${legalCase.amount} ${"currency".tr()}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: AppFonts.bold,
                        ),
                      ),
                    ],
                  )
                else
                  const SizedBox(),
                if (legalCase.hearingDate != null)
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 16, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 4),
                      Text(
                        legalCase.hearingDate!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
