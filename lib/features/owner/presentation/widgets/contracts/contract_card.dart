import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/contract_item_entity.dart';
import 'contract_status_badge.dart';

class ContractCard extends StatelessWidget {
  final ContractItemEntity contract;
  final VoidCallback? onTap;

  const ContractCard({
    super.key,
    required this.contract,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = contract.unitName.isNotEmpty
        ? '${contract.propertyName} • ${contract.unitName}'
        : contract.propertyName;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.circularLg,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.circularLg,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopHeader(context),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                _buildTenantRow(context),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.borderLight, height: 1),
                ),
                _buildFinancialAndTimelineRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.description_outlined, size: 18, color: context.primaryColor),
            const SizedBox(width: 6),
            Text(
              contract.contractNumber,
              style: TextStyle(
                color: context.primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        ContractStatusBadge(status: contract.status),
      ],
    );
  }

  Widget _buildTenantRow(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.person_outline, size: 16, color: AppColors.textSecondaryLight),
        const SizedBox(width: 6),
        Text(
          '${LocaleKeys.contractsTenantLabel.tr()} ',
          style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
        ),
        Expanded(
          child: Text(
            contract.tenantName,
            style: const TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialAndTimelineRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.contractsRentAmountLabel.tr(),
              style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11.5),
            ),
            const SizedBox(height: 2),
            Text(
              '${contract.rentAmount.toStringAsFixed(0)} ${_getCycleLabel()}',
              style: TextStyle(
                color: context.primaryColor,
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        if (contract.startDate.isNotEmpty && contract.endDate.isNotEmpty)
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondaryLight),
              const SizedBox(width: 5),
              Text(
                '${contract.startDate} - ${contract.endDate}',
                style: const TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
      ],
    );
  }

  String _getCycleLabel() {
    switch (contract.paymentCycle.toLowerCase()) {
      case 'monthly':
        return LocaleKeys.contractsCycleMonthly.tr();
      case 'annual':
      case 'yearly':
        return LocaleKeys.contractsCycleAnnual.tr();
      case 'quarterly':
        return LocaleKeys.contractsCycleQuarterly.tr();
      default:
        return LocaleKeys.contractsCycleCustom.tr();
    }
  }
}
