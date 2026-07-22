import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> stepLabels;
  final Set<int> savedSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.stepLabels,
    required this.savedSteps,
  });

  @override
  Widget build(BuildContext context) {
    final total = stepLabels.isEmpty ? 4 : stepLabels.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: List.generate(total, (index) {
              final isCurrent = index == currentStep;
              final isSaved = savedSteps.contains(index);
              final isPassed = index < currentStep;

              return Expanded(
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isSaved
                            ? AppColors.success
                            : isCurrent
                                ? context.primaryColor
                                : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent
                              ? context.primaryColor
                              : isSaved
                                  ? AppColors.success
                                  : const Color(0xFFCBD5E1),
                          width: 2,
                        ),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: context.primaryShadow,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: isSaved
                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCurrent ? Colors.white : AppColors.textSecondaryLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    if (index < total - 1)
                      Expanded(
                        child: Container(
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: isPassed || isSaved
                                ? AppColors.success
                                : const Color(0xFFE2E8F0),
                            borderRadius: AppRadius.circularFull,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          if (stepLabels.isNotEmpty && currentStep < stepLabels.length) ...[
            const SizedBox(height: 8),
            Text(
              stepLabels[currentStep],
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.primaryColor,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
