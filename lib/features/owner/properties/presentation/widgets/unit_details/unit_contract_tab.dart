import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: AppResponsiveContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (contract != null) ...[
              UnitContractBanner(contract: contract),
              const SizedBox(height: 24),
            ],
            if (history.isNotEmpty) ...[
              Text(
                LocaleKeys.unitDetailsContractHistory.tr(),
                style: const TextStyle(
                  fontFamily: AppFonts.fontFamilyPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                contract.contractNumber,
                style: const TextStyle(
                  fontFamily: AppFonts.fontFamilyPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.textSecondaryLight.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Text(
                  contract.statusLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${LocaleKeys.contractsTenantLabel.tr()}: ${contract.renterName}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontFamily: AppFonts.fontFamilyPrimary,
            ),
          ),
          if (contract.startDate != null && contract.endDate != null) ...[
            const SizedBox(height: 4),
            Text(
              '${contract.startDate} - ${contract.endDate}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontFamily: AppFonts.fontFamilyPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
