import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/contract_item_entity.dart';
import 'contract_status_badge.dart';

class ContractCard extends StatelessWidget {
  final ContractItemEntity contract;
  final VoidCallback? onTap;

  const ContractCard({super.key, required this.contract, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ContractHeader(contract: contract),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _locationLabel,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.appOnSurfaceColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(Icons.person_outline, size: 17, color: context.primaryColor),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  contract.tenantName.isEmpty ? '-' : contract.tenantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.appSecondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(color: context.appBorderColor, height: 1),
          const SizedBox(height: AppSpacing.sm),
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
        Icon(Icons.description_outlined, size: 18, color: context.primaryColor),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            contract.contractNumber,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelLarge.copyWith(
              color: context.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ContractStatusBadge(status: contract.status),
        const SizedBox(width: AppSpacing.xs),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: context.appSecondaryTextColor,
        ),
      ],
    );
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
            '${contract.rentAmount.toStringAsFixed(0)} '
            '${LocaleKeys.contractsCurrency.tr()}',
            style: AppTextStyles.h4.copyWith(color: context.primaryColor),
          ),
        ),
        if (contract.startDate.isNotEmpty && contract.endDate.isNotEmpty)
          Text(
            '${contract.startDate} – ${contract.endDate}',
            style: AppTextStyles.labelSmall.copyWith(
              color: context.appSecondaryTextColor,
            ),
          ),
      ],
    );
  }
}
