import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../domain/entities/contract_details_entity.dart';
import 'contract_details_row.dart';
import 'contract_section_header.dart';

class ContractDetailsPropertyCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDetailsPropertyCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContractSectionHeader(
            icon: Icons.business_outlined,
            title: LocaleKeys.contractsSectionPropertyUnit.tr(),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.06),
              borderRadius: AppRadius.circularLg,
              border: Border.all(
                color: context.primaryColor.withValues(alpha: 0.16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.apartment_rounded,
                  color: context.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contract.propertyName.isEmpty
                            ? '-'
                            : contract.propertyName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: context.appOnSurfaceColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (contract.unitName.isNotEmpty)
                        Text(
                          contract.unitName,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: context.appSecondaryTextColor,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  _typeLabel,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (contract.branchName.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Divider(color: context.appBorderColor, height: 1),
            ContractDetailsRow(
              label: LocaleKeys.contractsBranch.tr(),
              value: contract.branchName,
              showDivider: false,
            ),
          ],
        ],
      ),
    );
  }

  String get _typeLabel {
    final type = contract.contractType.toLowerCase();
    if (type.contains('commercial')) {
      return LocaleKeys.contractsTypeCommercial.tr();
    }
    if (type.contains('land')) return LocaleKeys.contractsTypeLand.tr();
    if (type.contains('admin')) return LocaleKeys.contractsTypeAdmin.tr();
    return LocaleKeys.contractsTypeResidential.tr();
  }
}
