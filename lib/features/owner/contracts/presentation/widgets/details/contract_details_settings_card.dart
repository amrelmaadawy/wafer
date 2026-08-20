import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/contract_details_entity.dart';
import '../../../domain/entities/contract_status_extension.dart';
import 'contract_details_row.dart';
import 'contract_section_header.dart';
import 'owner_update_contract_settings_sheet.dart';

class ContractDetailsSettingsCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDetailsSettingsCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ContractSectionHeader(
                  icon: Icons.settings_rounded,
                  title: LocaleKeys.contractsSectionSettings.tr(),
                ),
              ),
              if (contract.isEditable || contract.isActive)
                IconButton(
                  onPressed: () => OwnerUpdateContractSettingsSheet.show(
                    context,
                    contract,
                  ),
                  icon: const Icon(Icons.edit_rounded, size: 20),
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 32,
                    height: 32,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ContractDetailsRow(
            label: LocaleKeys.contractsAutoRenewal.tr(),
            value: contract.autoRenewalLabel,
            valueColor: contract.autoRenewal ? AppColors.success : null,
          ),
          ContractDetailsRow(
            label: LocaleKeys.contractsRenewalNoticeDays.tr(),
            value: contract.renewalNoticeDays.toString(),
          ),
          ContractDetailsRow(
            label: LocaleKeys.contractsTerminationPenalty.tr(),
            value: '${contract.terminationPenalty} ${LocaleKeys.contractsCurrency.tr()}',
          ),
          ContractDetailsRow(
            label: LocaleKeys.contractsSublettingAllowed.tr(),
            value: contract.sublettingAllowedLabel,
            trailingIcon: const Icon(Icons.vpn_key_rounded, size: 16),
          ),
          if (contract.notes != null && contract.notes!.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(),
            ),
            ContractDetailsRow(
              label: LocaleKeys.contractNotes.tr(),
              value: contract.notes!,
              trailingIcon: const Icon(Icons.notes_rounded, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}
