import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../domain/entities/contract_entity.dart';
import '../../../domain/entities/unit_full_details_entity.dart';
import '../details/unit_contract_banner.dart';

class UnitContractTab extends StatelessWidget {
  final UnitFullDetailsEntity unit;

  const UnitContractTab({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final contract = unit.currentContract;
    final history = unit.contractsHistory;

    if (contract == null && history.isEmpty) {
      return CustomEmptyWidget(
        icon: Icons.assignment_outlined,
        title: LocaleKeys.unitDetailsNoContract.tr(),
        subtitle: LocaleKeys.unitDetailsNoContractSubtitle.tr(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: AppResponsiveContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (contract != null) ...[
              UnitContractBanner(contract: contract),
              const SizedBox(height: AppSpacing.xl),
            ],
            if (history.isNotEmpty) ...[
              Text(
                LocaleKeys.unitDetailsContractHistory.tr(),
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.appOnSurfaceColor,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...history.map((c) => _ContractHistoryCard(contract: c)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContractHistoryCard extends StatelessWidget {
  final ContractEntity contract;

  const _ContractHistoryCard({required this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: context.appBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                contract.contractNumber,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.appOnSurfaceColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.appSecondaryTextColor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Text(
                  contract.statusLabel,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.appSecondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${LocaleKeys.contractsTenantLabel.tr()}: ${contract.renterName}',
            style: AppTextStyles.bodySmall.copyWith(
              color: context.appSecondaryTextColor,
            ),
          ),
          if (contract.startDate != null && contract.endDate != null) ...[
            const SizedBox(height: 4),
            Text(
              '${contract.startDate} - ${contract.endDate}',
              style: AppTextStyles.labelSmall.copyWith(
                color: context.appSecondaryTextColor.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
