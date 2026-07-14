import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../domain/entities/contract_details_entity.dart';
import '../contract_status_badge.dart';

class ContractDetailsHeaderCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDetailsHeaderCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularLg,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  contract.contractNumber,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                ),
              ),
              ContractStatusBadge(status: contract.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: contract.isEjarLinked
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.borderLight.withValues(alpha: 0.5),
                  borderRadius: AppRadius.circularSm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      contract.isEjarLinked ? Icons.verified_outlined : Icons.info_outline,
                      size: 15,
                      color: contract.isEjarLinked ? AppColors.success : AppColors.textSecondaryLight,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      contract.isEjarLinked
                          ? LocaleKeys.contractsEjarLinked.tr()
                          : LocaleKeys.contractsEjarNotLinked.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: contract.isEjarLinked ? AppColors.success : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
