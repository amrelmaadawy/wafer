import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import 'legal_case_wizard_card.dart';

class LegalCaseCourtAndPartiesCard extends StatelessWidget {
  final TextEditingController courtController;
  final TextEditingController circuitController;
  final TextEditingController plaintiffController;
  final TextEditingController defendantController;

  const LegalCaseCourtAndPartiesCard({
    super.key,
    required this.courtController,
    required this.circuitController,
    required this.plaintiffController,
    required this.defendantController,
  });

  @override
  Widget build(BuildContext context) {
    return LegalCaseWizardCard(
      title: LocaleKeys.court_and_parties.tr(),
      children: [
        CustomTextField(
          controller: courtController,
          label: LocaleKeys.court.tr(),
          hintText: LocaleKeys.enter_court.tr(),
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          controller: circuitController,
          label: LocaleKeys.circuit.tr(),
          hintText: LocaleKeys.enter_circuit.tr(),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Parties
        Text(
          LocaleKeys.parties.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              CustomTextField(
                controller: plaintiffController,
                label: LocaleKeys.plaintiff.tr(),
                hintText: LocaleKeys.enter_plaintiff.tr(),
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: defendantController,
                label: LocaleKeys.defendant.tr(),
                hintText: LocaleKeys.enter_defendant.tr(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
