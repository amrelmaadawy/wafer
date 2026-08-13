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
import 'owner_quick_action_card.dart';

class OwnerQuickActions extends StatelessWidget {
  const OwnerQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      OwnerQuickActionCard(
        title: LocaleKeys.maintenance_title.tr(),
        icon: Icons.build_circle_outlined,
        color: AppColors.error,
        onTap: () => context.push(Routes.ownerMaintenance),
      ),
      OwnerQuickActionCard(
        title: LocaleKeys.dashboard_reports.tr(),
        icon: Icons.bar_chart_rounded,
        color: AppColors.warning,
        onTap: () => context.push('${Routes.ownerReportsCenter}?tab=0'),
      ),
      OwnerQuickActionCard(
        title: LocaleKeys.legal_cases.tr(),
        icon: Icons.gavel_rounded,
        color: AppColors.accent,
        onTap: () => context.push(Routes.ownerLegalCases),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.grid_view_rounded,
              size: 17,
              color: context.appSecondaryTextColor,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              LocaleKeys.dashboard_quick_actions.tr(),
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
                  SizedBox(width: 130, child: cards[index]),
            ),
          )
        else
          Row(
            children: [
              for (var index = 0; index < cards.length; index++) ...[
                if (index > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(child: SizedBox(height: 110, child: cards[index])),
              ],
            ],
          ),
      ],
    );
  }
}
