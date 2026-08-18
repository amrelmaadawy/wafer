import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
              onTap: () => context.push(Routes.ownerTasks),
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
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadius.circularXl,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circularXl,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.appSurfaceColor,
            borderRadius: AppRadius.circularXl,
            border: Border.all(color: context.appBorderColor),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height: 2.5, color: color),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: AppRadius.circularMd,
                          ),
                          child: Icon(icon, color: color, size: 16),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: context.appSecondaryTextColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      value,
                      style: AppTextStyles.h3.copyWith(
                        color: context.appOnSurfaceColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: context.appSecondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: AppRadius.circularFull,
                      ),
                      child: Text(
                        '$subtitle: $subtitleValue',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
