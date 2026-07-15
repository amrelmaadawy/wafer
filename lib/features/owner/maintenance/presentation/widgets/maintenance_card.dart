import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import 'maintenance_status_badge.dart';

class MaintenanceCard extends StatelessWidget {
  final MaintenanceItemEntity item;
  final VoidCallback? onTap;

  const MaintenanceCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locationTitle = item.unit.name.isNotEmpty
        ? '${item.property.name} • ${item.unit.name}'
        : item.property.name.isNotEmpty
            ? item.property.name
            : LocaleKeys.maintenanceNotDeterminedYet.tr();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.circularXxl,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.circularXxl,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopHeader(context),
                const SizedBox(height: 12),
                Text(
                  locationTitle,
                  style: const TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                _buildCostBearerRow(context),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.borderLight, height: 1),
                ),
                _buildFinancialRow(context),
                if (item.advancePayment > 0 || item.requestedDate.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _buildBottomTimelineRow(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.build_circle_outlined,
                  size: 18, color: context.primaryColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.title.isNotEmpty ? item.title : '#${item.id}',
                  style: TextStyle(
                    color: context.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            MaintenanceStatusBadge(
              status: item.status,
              statusLabel: item.statusLabel,
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textSecondaryLight.withValues(alpha: 0.6),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCostBearerRow(BuildContext context) {
    final bearerDisplay = item.costBearerLabel.isNotEmpty
        ? item.costBearerLabel
        : item.costBearer == 'client'
            ? LocaleKeys.maintenanceCostBearerClient.tr()
            : LocaleKeys.maintenanceCostBearerOwner.tr();

    return Row(
      children: [
        const Icon(Icons.person_outline,
            size: 16, color: AppColors.textSecondaryLight),
        const SizedBox(width: 6),
        Text(
          '${LocaleKeys.maintenanceCostBearerLabel.tr()}: ',
          style:
              const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
        ),
        Text(
          bearerDisplay,
          style: const TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCostItem(
          context,
          LocaleKeys.maintenanceEstimatedCost.tr(),
          item.estimatedCost,
          context.primaryColor,
        ),
        _buildCostItem(
          context,
          LocaleKeys.maintenanceActualCost.tr(),
          item.actualCost,
          item.actualCost > 0 ? AppColors.success : AppColors.textSecondaryLight,
        ),
      ],
    );
  }

  Widget _buildCostItem(
      BuildContext context, String label, double amount, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              color: AppColors.textSecondaryLight, fontSize: 11.5),
        ),
        const SizedBox(height: 3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              amount > 0 ? amount.toStringAsFixed(0) : '--',
              style: TextStyle(
                color: valueColor,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (amount > 0) ...[
              const SizedBox(width: 4),
              Text(
                LocaleKeys.contractsCurrency.tr(),
                style: TextStyle(
                  color: valueColor.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildBottomTimelineRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (item.requestedDate.isNotEmpty)
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 13, color: AppColors.textSecondaryLight),
              const SizedBox(width: 4),
              Text(
                item.requestedDate,
                style: const TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        else
          const SizedBox.shrink(),
        if (item.advancePayment > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.circularSm,
            ),
            child: Text(
              '${LocaleKeys.maintenanceAdvancePayment.tr()}: ${item.advancePayment.toStringAsFixed(0)} ${LocaleKeys.contractsCurrency.tr()}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: context.primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
