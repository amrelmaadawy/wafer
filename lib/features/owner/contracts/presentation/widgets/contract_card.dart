import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/presentation/widgets/app_status_badge.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/contract_item_entity.dart';

class ContractCard extends StatelessWidget {
  final ContractItemEntity contract;
  final VoidCallback? onTap;

  const ContractCard({super.key, required this.contract, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ContractHeader(contract: contract),
          const SizedBox(height: AppSpacing.md),
          Text(
            _locationLabel,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.appOnSurfaceColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_outline, size: 16, color: context.primaryColor),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  contract.renterName.isEmpty ? '-' : contract.renterName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.appSecondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Divider(color: context.appBorderColor, height: 1),
          const SizedBox(height: AppSpacing.lg),
          _ContractFooter(contract: contract),
        ],
      ),
    );
  }

  String get _locationLabel {
    final parts = [
      contract.propertyName,
      contract.unitName,
    ].where((value) => value.isNotEmpty).toList(growable: false);
    return parts.isEmpty ? '-' : parts.join(' · ');
  }
}

class _ContractHeader extends StatelessWidget {
  final ContractItemEntity contract;

  const _ContractHeader({required this.contract});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.description_outlined, size: 20, color: context.primaryColor),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            contract.contractNumber,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelLarge.copyWith(
              color: context.primaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        AppStatusBadge(
          labelKey: contract.statusLabel.isNotEmpty ? contract.statusLabel : contract.status,
          color: _getStatusColor(contract.status),
          size: AppStatusBadgeSize.small,
          translateText: false,
        ),
        const SizedBox(width: AppSpacing.sm),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: context.appSecondaryTextColor.withValues(alpha: 0.5),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase().trim()) {
      case 'active':
      case 'sari':
        return AppColors.success;
      case 'expiring':
      case 'expiring_soon':
        return AppColors.warning;
      case 'draft':
        return AppColors.textSecondaryLight;
      case 'terminated':
      case 'cancelled':
        return AppColors.error;
      case 'renewed':
        return AppColors.info;
      default:
        return AppColors.textPrimaryLight;
    }
  }
}

class _ContractFooter extends StatelessWidget {
  final ContractItemEntity contract;

  const _ContractFooter({required this.contract});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            '${contract.totalRentValue.toStringAsFixed(0)} '
            '${LocaleKeys.contractsCurrency.tr()}',
            style: AppTextStyles.h3.copyWith(
              color: context.primaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (contract.startDate.isNotEmpty && contract.endDate.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: context.appSurfaceColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.appBorderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.date_range_rounded,
                  size: 14,
                  color: context.appSecondaryTextColor,
                ),
                const SizedBox(width: 6),
                Text(
                  '${contract.startDate} – ${contract.endDate}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: context.appSecondaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
