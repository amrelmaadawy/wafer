import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../domain/entities/contract_details_entity.dart';

class ContractDetailsFinancialCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDetailsFinancialCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    String cycleLabel = LocaleKeys.contractsCycleMonthly.tr();
    final cycleLower = contract.paymentCycle.toLowerCase();
    if (cycleLower.contains('annual') || cycleLower.contains('yearly')) {
      cycleLabel = LocaleKeys.contractsCycleAnnual.tr();
    } else if (cycleLower.contains('quarter')) {
      cycleLabel = LocaleKeys.contractsCycleQuarterly.tr();
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.contractsSectionFinancial.tr(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.04),
              borderRadius: AppRadius.circularLg,
              border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.contractsTotalRentValue.tr(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${contract.totalRentValue.toStringAsFixed(0)} ${LocaleKeys.contractsCurrency.tr()}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: AppRadius.circularMd,
                  ),
                  child: Text(
                    cycleLabel,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildRowItem(
            LocaleKeys.contractsPaymentCount.tr(),
            '${contract.paymentCount} ${LocaleKeys.contractsPaymentCountUnit.tr()}',
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 12),
          _buildRowItem(
            LocaleKeys.contractsSecurityDeposit.tr(),
            '${contract.securityDeposit.toStringAsFixed(0)} ${LocaleKeys.contractsCurrency.tr()}',
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 12),
          _buildRowItem(
            LocaleKeys.contractsStartDateLabel.tr(),
            contract.startDate.isNotEmpty ? _formatDate(contract.startDate) : '-',
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 12),
          _buildRowItem(
            LocaleKeys.contractsEndDateLabel.tr(),
            contract.endDate.isNotEmpty ? _formatDate(contract.endDate) : '-',
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondaryLight),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return '-';
    try {
      final parts = isoDate.split('-');
      if (parts.length != 3) return isoDate;
      final months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
      final month = int.tryParse(parts[1]) ?? 1;
      return '${parts[2]} ${months[month - 1]} ${parts[0]}';
    } catch (_) {
      return isoDate;
    }
  }
}
