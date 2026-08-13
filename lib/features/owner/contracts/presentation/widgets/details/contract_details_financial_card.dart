import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../domain/entities/contract_details_entity.dart';
import 'contract_section_header.dart';

class ContractDetailsFinancialCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDetailsFinancialCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContractSectionHeader(
            icon: Icons.account_balance_wallet_outlined,
            title: LocaleKeys.contractsSectionFinancial.tr(),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            LocaleKeys.contractsTotalRentValue.tr(),
            style: AppTextStyles.bodySmall.copyWith(
              color: context.appSecondaryTextColor,
            ),
          ),
          Text(
            '${contract.totalRentValue.toStringAsFixed(0)} '
            '${LocaleKeys.contractsCurrency.tr()}',
            style: AppTextStyles.h3.copyWith(color: context.primaryColor),
          ),
          const SizedBox(height: AppSpacing.md),
          _FinancialRow(
            label: LocaleKeys.contractsPaymentCount.tr(),
            value:
                '${contract.paymentCount} '
                '${LocaleKeys.contractsPaymentCountUnit.tr()}',
          ),
          _FinancialRow(
            label: LocaleKeys.contractsSecurityDeposit.tr(),
            value:
                '${contract.securityDeposit.toStringAsFixed(0)} '
                '${LocaleKeys.contractsCurrency.tr()}',
          ),
          _FinancialRow(
            label: LocaleKeys.contractsStartDateLabel.tr(),
            value: _formatDate(context, contract.startDate),
          ),
          _FinancialRow(
            label: LocaleKeys.contractsEndDateLabel.tr(),
            value: _formatDate(context, contract.endDate),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value.isEmpty ? '-' : value;
    return DateFormat.yMMMd(context.locale.toString()).format(date);
  }
}

class _FinancialRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const _FinancialRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.appSecondaryTextColor,
                  ),
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.appOnSurfaceColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(color: context.appBorderColor, height: 1),
      ],
    );
  }
}
