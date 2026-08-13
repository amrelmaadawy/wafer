import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/owner_dashboard_entity.dart';

class OwnerTasksLegalCard extends StatelessWidget {
  final TasksBreakdownEntity? tasks;
  final LegalCasesBreakdownEntity? legalCases;

  const OwnerTasksLegalCard({super.key, this.tasks, this.legalCases});

  @override
  Widget build(BuildContext context) {
    if (tasks == null && legalCases == null) return const SizedBox.shrink();
    return Row(
      children: [
        if (tasks != null)
          Expanded(
            child: _BreakdownCard(
              icon: Icons.task_alt_rounded,
              title: LocaleKeys.dashboard_tasks_active.tr(),
              value: '${tasks!.active}',
              subtitle: LocaleKeys.dashboard_tasks_overdue.tr(),
              subtitleValue: '${tasks!.overdue}',
              color: AppColors.info,
            ),
          ),
        if (tasks != null && legalCases != null)
          const SizedBox(width: AppSpacing.md),
        if (legalCases != null)
          Expanded(
            child: _BreakdownCard(
              icon: Icons.gavel_rounded,
              title: LocaleKeys.dashboard_legal_open.tr(),
              value: '${legalCases!.openCases}',
              subtitle: LocaleKeys.dashboard_legal_amount.tr(),
              subtitleValue: LocaleKeys.commonCurrencySar.tr(
                args: [legalCases!.totalAmount.toStringAsFixed(0)],
              ),
              color: AppColors.warning,
              onTap: () => context.push(Routes.ownerLegalCases),
            ),
          ),
      ],
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final String subtitleValue;
  final Color color;
  final VoidCallback? onTap;

  const _BreakdownCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.subtitleValue,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: context.appSecondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(color: context.appOnSurfaceColor),
          ),
          Text.rich(
            TextSpan(
              text: '$subtitle ',
              children: [
                TextSpan(
                  text: subtitleValue,
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            style: AppTextStyles.labelSmall.copyWith(
              color: context.appSecondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
