import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/maintenance_item_entity.dart';

class MaintenanceCostSection extends StatelessWidget {
  final MaintenanceItemEntity item;

  const MaintenanceCostSection({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined,
                  size: 20, color: context.primaryColor),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.maintenanceCostSection.tr(),
                style: const TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCostBox(
                  context,
                  LocaleKeys.maintenanceEstimatedCost.tr(),
                  item.estimatedCost,
                  context.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCostBox(
                  context,
                  LocaleKeys.maintenanceActualCost.tr(),
                  item.actualCost,
                  item.actualCost > 0
                      ? AppColors.success
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBearerAndAdvanceRow(context),
        ],
      ),
    );
  }

  Widget _buildCostBox(
      BuildContext context, String title, double amount, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: valueColor.withValues(alpha: 0.06),
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: valueColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                amount > 0 ? amount.toStringAsFixed(0) : '--',
                style: TextStyle(
                  color: valueColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                LocaleKeys.contractsCurrency.tr(),
                style: TextStyle(
                  color: valueColor.withValues(alpha: 0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBearerAndAdvanceRow(BuildContext context) {
    final bearerDisplay = item.costBearerLabel.isNotEmpty
        ? item.costBearerLabel
        : item.costBearer == 'client'
            ? LocaleKeys.maintenanceCostBearerClient.tr()
            : LocaleKeys.maintenanceCostBearerOwner.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.circularLg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 16, color: AppColors.textSecondaryLight),
              const SizedBox(width: 6),
              Text(
                '${LocaleKeys.maintenanceCostBearerLabel.tr()}: ',
                style: const TextStyle(
                    color: AppColors.textSecondaryLight, fontSize: 13),
              ),
              Text(
                bearerDisplay,
                style: const TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (item.advancePayment > 0)
            Text(
              '${LocaleKeys.maintenanceAdvancePayment.tr()}: ${item.advancePayment.toStringAsFixed(0)} ${LocaleKeys.contractsCurrency.tr()}',
              style: TextStyle(
                color: context.primaryColor,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}
