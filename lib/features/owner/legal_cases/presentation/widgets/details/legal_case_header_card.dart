import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/legal_case_item_entity.dart';
import '../../utils/legal_case_status_utils.dart';
import 'legal_case_info_column.dart';

class LegalCaseHeaderCard extends StatelessWidget {
  final LegalCaseItemEntity legalCase;

  const LegalCaseHeaderCard({super.key, required this.legalCase});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                legalCase.caseNumber ?? '',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textPrimaryLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: LegalCaseStatusUtils.getStatusColor(
                    legalCase.statusColor,
                    context,
                  ).withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Text(
                  legalCase.status ?? '',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: LegalCaseStatusUtils.getStatusColor(
                      legalCase.statusColor,
                      context,
                    ),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: LegalCaseInfoColumn(
                  label: LocaleKeys.case_type.tr(),
                  value: legalCase.caseType ?? '-',
                ),
              ),
              Expanded(
                child: LegalCaseInfoColumn(
                  label: LocaleKeys.court.tr(),
                  value: legalCase.court ?? '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: LegalCaseInfoColumn(
                  label: LocaleKeys.circuit.tr(),
                  value: legalCase.circuit ?? '-',
                ),
              ),
              Expanded(
                child: LegalCaseInfoColumn(
                  label: LocaleKeys.amount.tr(),
                  value: legalCase.amount != null
                      ? '${legalCase.amount} ${LocaleKeys.currency.tr()}'
                      : '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
