import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/color_utils.dart';

class WizardProgressBar extends StatelessWidget {
  final int currentStep; // 0 to 4
  const WizardProgressBar({super.key, required this.currentStep});

  final List<String> _titles = const [
    LocaleKeys.propertyWizardStep1Title,
    LocaleKeys.propertyWizardStep2Title,
    LocaleKeys.propertyWizardStep3Title,
    LocaleKeys.propertyWizardStep4Title,
    LocaleKeys.propertyWizardStep5Title,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Row(
                  children: [
                    _buildStepIndicator(context, index),
                    if (index < 4)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index < currentStep
                              ? context.primaryColor
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _titles[currentStep].tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              Text(
                '${currentStep + 1} / 5',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context, int index) {
    final isActive = index <= currentStep;
    final isCompleted = index < currentStep;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isActive ? context.primaryColor : const Color(0xFFF1F5F9),
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? context.primaryColor : const Color(0xFFCBD5E1),
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
