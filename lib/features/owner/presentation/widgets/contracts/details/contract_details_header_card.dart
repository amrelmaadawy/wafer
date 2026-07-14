import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../domain/entities/contract_details_entity.dart';
import '../contract_status_badge.dart';

class ContractDetailsHeaderCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDetailsHeaderCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.08),
            primaryColor.withValues(alpha: 0.03),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: primaryColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          // Top accent bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.description_rounded, color: primaryColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.contractsContractNumberLabel.tr(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            contract.contractNumber,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: primaryColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ContractStatusBadge(status: contract.status),
                  ],
                ),
                if (contract.isEjarLinked || true) ...[
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: AppColors.borderLight),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: contract.isEjarLinked
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.borderLight.withValues(alpha: 0.5),
                          borderRadius: AppRadius.circularSm,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              contract.isEjarLinked
                                  ? Icons.verified_rounded
                                  : Icons.info_outline_rounded,
                              size: 15,
                              color: contract.isEjarLinked
                                  ? AppColors.success
                                  : AppColors.textSecondaryLight,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              contract.isEjarLinked
                                  ? LocaleKeys.contractsEjarLinked.tr()
                                  : LocaleKeys.contractsEjarNotLinked.tr(),
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: contract.isEjarLinked
                                    ? AppColors.success
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
