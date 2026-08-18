import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../domain/entities/contract_entity.dart';

class PropertyContractsTab extends StatelessWidget {
  final List<ContractEntity> contracts;

  const PropertyContractsTab({super.key, required this.contracts});

  @override
  Widget build(BuildContext context) {
    if (contracts.isEmpty) {
      return CustomEmptyWidget(
        icon: Icons.assignment_outlined,
        title: LocaleKeys.contractsNoContractsTitle.tr(),
        subtitle: LocaleKeys.dashboard_no_data.tr(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      itemCount: contracts.length,
      itemBuilder: (context, index) {
        final contract = contracts[index];
        final isDraft = contract.status == 'draft';
        final statusColor = isDraft ? AppColors.warning : AppColors.success;

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          color: context.appSurfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.circularXl,
            side: BorderSide(color: context.appBorderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      contract.contractNumber,
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.appOnSurfaceColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: AppRadius.circularMd,
                      ),
                      child: Text(
                        contract.statusLabel,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${LocaleKeys.contractsSectionPropertyUnit.tr()}: ${contract.unitName}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.appSecondaryTextColor,
                  ),
                ),
                Text(
                  '${LocaleKeys.contractsTenantLabel.tr()}: ${contract.renterName}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.appSecondaryTextColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${LocaleKeys.contractsTotalRentValue.tr()}: ${contract.totalRentValue} ${LocaleKeys.commonCurrencySar.tr()}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: context.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${LocaleKeys.contractsTypeLabel.tr()}: ${contract.contractType}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: context.appSecondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
