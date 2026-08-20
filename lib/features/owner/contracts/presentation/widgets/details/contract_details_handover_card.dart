import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/contract_details_entity.dart';
import 'contract_details_row.dart';
import 'contract_section_header.dart';

class ContractDetailsHandoverCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDetailsHandoverCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContractSectionHeader(
            icon: Icons.key_rounded,
            title: LocaleKeys.contractsSectionHandover.tr(),
          ),
          const SizedBox(height: AppSpacing.md),
          ContractDetailsRow(
            label: LocaleKeys.contractsHandoverStatus.tr(),
            value: contract.isHandedOverLabel,
            valueColor: contract.isHandedOver ? AppColors.success : AppColors.textSecondaryLight,
            showDivider: contract.isHandedOver,
          ),
          if (contract.isHandedOver)
            ContractDetailsRow(
              label: LocaleKeys.contractsHandoverDate.tr(),
              value: contract.handoverDate,
              showDivider: false,
            ),
        ],
      ),
    );
  }
}
