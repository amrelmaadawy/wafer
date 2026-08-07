import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../domain/entities/contracts_report_item_entity.dart';

class ContractsReportItemCard extends StatelessWidget {
  final ContractsReportItemEntity contract;

  const ContractsReportItemCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final statusColor = contract.status.toLowerCase() == 'active'
        ? const Color(0xFF10B981)
        : contract.status.toLowerCase() == 'expired'
        ? AppColors.error
        : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.description_rounded,
                        color: Color(0xFF6366F1),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contract.propertyName.isNotEmpty
                                ? contract.propertyName
                                : LocaleKeys.reports_unnamedProperty.tr(),
                            style: const TextStyle(
                              color: AppColors.textPrimaryLight,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${LocaleKeys.reports_unit.tr()}: ${contract.unitName.isNotEmpty ? contract.unitName : LocaleKeys.reports_notAvailable.tr()}',
                            style: const TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.circularFull,
                ),
                child: Text(
                  contract.statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: AppRadius.circularLg,
              border: Border.all(
                color: AppColors.borderLight.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.reports_renter.tr(),
                        style: const TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contract.renterName.isNotEmpty
                            ? contract.renterName
                            : LocaleKeys.reports_notAvailable.tr(),
                        style: const TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.reports_rentValue.tr(),
                        style: const TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${contract.totalRentValue.toStringAsFixed(0)} ${LocaleKeys.contractsCurrency.tr()}',
                        style: const TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${LocaleKeys.reports_contractStart.tr()}: ${contract.startDate}',
                style: const TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                LocaleKeys.reports_expiresOn.tr(args: [contract.endDate]),
                style: const TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
