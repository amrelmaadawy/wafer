import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/presentation/widgets/custom_empty_widget.dart';
import 'package:wafer/core/theme/app_radius.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/color_utils.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: contracts.length,
      itemBuilder: (context, index) {
        final contract = contracts[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.circularXl,
            side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      contract.contractNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: contract.status == 'draft'
                            ? AppColors.warning.withValues(alpha: 0.1)
                            : AppColors.success.withValues(alpha: 0.1),
                        borderRadius: AppRadius.circularMd,
                      ),
                      child: Text(
                        contract.statusLabel,
                        style: TextStyle(
                          color: contract.status == 'draft'
                              ? AppColors.warning
                              : AppColors.success,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${LocaleKeys.contractsSectionPropertyUnit.tr()}: ${contract.unitName}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  '${LocaleKeys.contractsTenantLabel.tr()}: ${contract.renterName}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${LocaleKeys.contractsTotalRentValue.tr()}: ${contract.totalRentValue} ${LocaleKeys.commonCurrencySar.tr()}',
                      style: TextStyle(
                        color: context.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${LocaleKeys.contractsTypeLabel.tr()}: ${contract.contractType}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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

