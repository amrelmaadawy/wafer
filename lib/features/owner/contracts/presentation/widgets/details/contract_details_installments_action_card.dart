import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';

class ContractDetailsInstallmentsActionCard extends StatelessWidget {
  final String contractId;
  final String contractNumber;
  final int? installmentsCount;

  const ContractDetailsInstallmentsActionCard({
    super.key,
    required this.contractId,
    this.contractNumber = '',
    this.installmentsCount,
  });

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      onTap: () => context.push(
        Routes.ownerContractInstallmentsPath(contractId),
        extra: contractNumber,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: context.primaryColor.withValues(alpha: 0.12),
            foregroundColor: context.primaryColor,
            child: const Icon(Icons.account_balance_wallet_rounded),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.installmentsTitle.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.appOnSurfaceColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  installmentsCount == null
                      ? LocaleKeys.installmentsCardSubtitle.tr()
                      : LocaleKeys.installmentsCountLabel.tr(
                          namedArgs: {'count': '$installmentsCount'},
                        ),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.appSecondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(Icons.arrow_forward_ios_rounded, color: context.primaryColor),
        ],
      ),
    );
  }
}
