import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';

class LegalCaseStepIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final List<String> stepTitles;
  final List<String> stepIcons;

  const LegalCaseStepIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.stepTitles,
    required this.stepIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.md),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(stepTitles.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Line between steps
            final lineIndex = index ~/ 2;
            final isCompleted = currentStep > lineIndex;
            return Expanded(
              child: Container(
                height: 2,
                color: isCompleted ? context.primaryColor : AppColors.borderLight,
              ),
            );
          } else {
            // Step circle
            final stepIndex = index ~/ 2;
            final isActive = currentStep == stepIndex;
            final isCompleted = currentStep > stepIndex;

            return _buildStepItem(
              context,
              isActive: isActive,
              isCompleted: isCompleted,
              title: stepTitles[stepIndex],
              icon: stepIcons[stepIndex],
              stepNumber: stepIndex + 1,
            );
          }
        }),
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required bool isActive,
    required bool isCompleted,
    required String title,
    required String icon,
    required int stepNumber,
  }) {
    final Color color = isActive || isCompleted ? context.primaryColor : AppColors.textSecondaryLight;
    final Color bgColor = isActive
        ? context.primaryColor.withValues(alpha: 0.1)
        : isCompleted
            ? context.primaryColor
            : AppColors.backgroundLight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            border: Border.all(
              color: isActive || isCompleted ? context.primaryColor : AppColors.borderLight,
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 20)
              : Text(
                  icon,
                  style: const TextStyle(fontSize: 16),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: isActive || isCompleted ? AppFonts.bold : AppFonts.medium,
          ),
        ),
      ],
    );
  }
}
