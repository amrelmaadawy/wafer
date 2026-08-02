import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import 'legal_case_wizard_card.dart';

class LegalCaseFinancialsCard extends StatelessWidget {
  final TextEditingController amountController;
  final DateTime? hearingDate;
  final VoidCallback onSelectDate;

  const LegalCaseFinancialsCard({
    super.key,
    required this.amountController,
    required this.hearingDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return LegalCaseWizardCard(
      title: LocaleKeys.financials_and_dates.tr(),
      children: [
        CustomTextField(
          controller: amountController,
          label: LocaleKeys.amount.tr(),
          hintText: '0.0',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefixIcon: const Icon(
            Icons.attach_money,
            color: AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          LocaleKeys.hearing_date.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: onSelectDate,
          borderRadius: AppRadius.circularMd,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: AppRadius.circularMd,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hearingDate != null
                      ? DateFormat('yyyy-MM-dd').format(hearingDate!)
                      : LocaleKeys.select_date.tr(),
                  style: TextStyle(
                    color: hearingDate != null
                        ? AppColors.textPrimaryLight
                        : AppColors.textSecondaryLight,
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: context.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
