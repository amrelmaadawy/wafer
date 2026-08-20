import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/contract_details_entity.dart';
import 'contract_details_row.dart';
import 'contract_section_header.dart';

class ContractDetailsEjarCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDetailsEjarCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContractSectionHeader(
            icon: Icons.link_rounded,
            title: LocaleKeys.contractsSectionEjar.tr(),
          ),
          const SizedBox(height: AppSpacing.md),
          ContractDetailsRow(
            label: LocaleKeys.contractsEjarStatus.tr(),
            value: contract.isEjarLinked ? contract.ejarStatusLabel : LocaleKeys.contractsEjarNotLinked.tr(),
            valueColor: contract.isEjarLinked ? AppColors.success : AppColors.textSecondaryLight,
          ),
          if (contract.isEjarLinked) ...[
            ContractDetailsRow(
              label: LocaleKeys.contractsEjarContractNumber.tr(),
              value: contract.ejarExternalContractNumber,
            ),
            ContractDetailsRow(
              label: LocaleKeys.contractsEjarReferenceNumber.tr(),
              value: contract.ejarReferenceNumber,
              showDivider: false,
            ),
          ] else
            const SizedBox(height: AppSpacing.sm), // Spacer if not linked
        ],
      ),
    );
  }
}
