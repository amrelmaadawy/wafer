import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/legal_case_item_entity.dart';
import 'legal_case_info_column.dart';

class LegalCasePropertyCard extends StatelessWidget {
  final LegalCaseItemEntity legalCase;

  const LegalCasePropertyCard({super.key, required this.legalCase});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.property_and_contract.tr(),
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: AppFonts.semiBold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: LegalCaseInfoColumn(
                  label: LocaleKeys.property_name.tr(),
                  value: legalCase.property?.name ?? '-',
                ),
              ),
              Expanded(
                child: LegalCaseInfoColumn(
                  label: LocaleKeys.contract_number.tr(),
                  value: legalCase.contract?.contractNumber ?? '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
