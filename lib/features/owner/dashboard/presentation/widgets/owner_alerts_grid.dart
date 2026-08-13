import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_breakpoints.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/owner_dashboard_entity.dart';
import 'owner_alert_card.dart';

class OwnerAlertsGrid extends StatelessWidget {
  final OwnerDashboardEntity data;

  const OwnerAlertsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cards = [
      OwnerAlertCard(
        title: LocaleKeys.ownerActiveContractsTitle.tr(),
        subtitle: LocaleKeys.ownerActiveContractsSub.tr(),
        count: data.activeContracts,
        color: AppColors.success,
        icon: Icons.description_rounded,
      ),
      OwnerAlertCard(
        title: LocaleKeys.ownerExpiringTitle.tr(),
        subtitle: LocaleKeys.ownerExpiringSub.tr(),
        count: data.expiringContracts,
        color: data.expiringContracts > 0
            ? AppColors.warning
            : context.appSecondaryTextColor,
        icon: Icons.update_rounded,
        highlight: data.expiringContracts > 0,
      ),
      OwnerAlertCard(
        title: LocaleKeys.ownerPendingMaintTitle.tr(),
        subtitle: LocaleKeys.ownerPendingMaintSub.tr(),
        count: data.pendingMaintenance,
        color: data.pendingMaintenance > 0
            ? AppColors.error
            : context.appSecondaryTextColor,
        icon: Icons.handyman_rounded,
        highlight: data.pendingMaintenance > 0,
        onTap: () => context.push('${Routes.ownerMaintenance}?filter=new'),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.bolt_rounded,
              size: 17,
              color: context.appSecondaryTextColor,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              LocaleKeys.ownerQuickAlerts.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.appOnSurfaceColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (context.isCompact)
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, index) =>
                  SizedBox(width: 140, child: cards[index]),
            ),
          )
        else
          Row(
            children: [
              for (var index = 0; index < cards.length; index++) ...[
                if (index > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(child: SizedBox(height: 120, child: cards[index])),
              ],
            ],
          ),
      ],
    );
  }
}
