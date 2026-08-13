import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../domain/entities/contract_details_entity.dart';
import '../contract_status_badge.dart';

class ContractDetailsHeaderCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDetailsHeaderCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final ejarColor = contract.isEjarLinked
        ? AppColors.success
        : context.appSecondaryTextColor;
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: context.primaryColor.withValues(alpha: 0.12),
                child: Icon(
                  Icons.description_rounded,
                  color: context.primaryColor,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.contractsContractNumberLabel.tr(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: context.appSecondaryTextColor,
                      ),
                    ),
                    Text(
                      contract.contractNumber.isEmpty
                          ? '-'
                          : contract.contractNumber,
                      style: AppTextStyles.h4.copyWith(
                        color: context.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              ContractStatusBadge(status: contract.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(color: context.appBorderColor, height: 1),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                contract.isEjarLinked
                    ? Icons.verified_rounded
                    : Icons.info_outline_rounded,
                color: ejarColor,
                size: 17,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                contract.isEjarLinked
                    ? LocaleKeys.contractsEjarLinked.tr()
                    : LocaleKeys.contractsEjarNotLinked.tr(),
                style: AppTextStyles.labelMedium.copyWith(color: ejarColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
