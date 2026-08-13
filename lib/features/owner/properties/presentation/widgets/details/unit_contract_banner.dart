import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/contract_entity.dart';

class UnitContractBanner extends StatelessWidget {
  final ContractEntity contract;

  const UnitContractBanner({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor,
            context.primaryColor.withValues(alpha: 0.80),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: AppRadius.circularXxl,
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: Colors.white70,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.owner_active_contracts_sub.tr(),
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white70,
                ),
              ),
              const Spacer(),
              if (contract.statusLabel.isNotEmpty)
                _StatusBadge(label: contract.statusLabel),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            contract.renterName.isEmpty ? '-' : contract.renterName,
            style: AppTextStyles.h4.copyWith(color: Colors.white),
          ),
          if (contract.startDate != null && contract.endDate != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.white60,
                  size: 13,
                ),
                const SizedBox(width: 6),
                Text(
                  '${contract.startDate} - ${contract.endDate}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;

  const _StatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: AppRadius.circularXxl,
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
      ),
    );
  }
}
