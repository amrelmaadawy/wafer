import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';
import '../../cubit/create/property_create_state.dart';

class CreatePropertyBottomNav extends StatelessWidget {
  final PropertyCreateState state;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const CreatePropertyBottomNav({
    super.key,
    required this.state,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = state.currentStep == 4;
    final isBusy =
        state.isSaving ||
        state.isSavingImages ||
        state.isSyncingOwners ||
        state.isPublishing ||
        state.isAutoSavingDetails;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (state.currentStep > 0)
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: isBusy ? null : onPrevious,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.circularLg,
                    ),
                    side: const BorderSide(color: AppColors.borderLight),
                  ),
                  child: Text(
                    LocaleKeys.propertyWizardPrevious.tr(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
            if (state.currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: isBusy
                  ? AppShimmer.box(
                      height: 52,
                      borderRadius: AppRadius.circularLg,
                    )
                  : ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLastStep
                            ? AppColors.success
                            : context.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.circularLg,
                        ),
                      ),
                      child: Text(
                        isLastStep
                            ? LocaleKeys.propertyWizardPublish.tr()
                            : LocaleKeys.propertyWizardNext.tr(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

