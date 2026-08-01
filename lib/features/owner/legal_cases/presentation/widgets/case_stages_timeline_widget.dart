import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../domain/entities/legal_case_item_entity.dart';

class CaseStagesTimelineWidget extends StatelessWidget {
  final List<LegalCaseStageEntity> stages;

  const CaseStagesTimelineWidget({
    super.key,
    required this.stages,
  });

  @override
  Widget build(BuildContext context) {
    if (stages.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...stages.asMap().entries.map((entry) {
          final index = entry.key;
          final stage = entry.value;
          final isLast = index == stages.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Timeline Line and Dot
                SizedBox(
                  width: 32,
                  child: Column(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStatusColor(stage.stageColor, context),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: _getStatusColor(stage.stageColor, context).withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: AppColors.borderLight,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Timeline Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.circularLg,
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
                                  stage.stageNameDisplay ?? stage.stageName ?? '',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: AppFonts.semiBold,
                                    color: AppColors.textPrimaryLight,
                                  ),
                                ),
                              ),
                              if (stage.stageDate != null)
                                Text(
                                  stage.stageDate!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondaryLight,
                                  ),
                                ),
                            ],
                          ),
                          if (stage.notes != null && stage.notes!.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              stage.notes!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

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
}
