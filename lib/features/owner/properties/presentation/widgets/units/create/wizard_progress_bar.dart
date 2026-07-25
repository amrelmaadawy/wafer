import 'package:flutter/material.dart';
import '../../../../../../../core/theme/color_utils.dart';
import '../../../../../../../core/theme/app_colors.dart';

class WizardProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const WizardProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الخطوة ${currentStep + 1} من $totalSteps',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              Text(
                _getStepTitle(currentStep),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0: return 'البيانات الأساسية';
      case 1: return 'المواصفات';
      case 2: return 'الموقع والمرافق';
      case 3: return 'الصور';
      case 4: return 'التفاصيل المالية';
      case 5: return 'مراجعة وتأكيد';
      default: return '';
    }
  }
}
