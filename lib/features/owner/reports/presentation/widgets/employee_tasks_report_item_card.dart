import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/employee_tasks_item_entity.dart';

class EmployeeTasksReportItemCard extends StatelessWidget {
  final EmployeeTasksItemEntity item;
  const EmployeeTasksReportItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: AppRadius.circularLg,
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: .1),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name.isEmpty ? '-' : item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      item.phone.isNotEmpty ? item.phone : item.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.appSecondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: context.appBorderColor),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _TaskMetric(
                  label: LocaleKeys.employeeTasksCompleted.tr(),
                  value: item.completedTasks,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _TaskMetric(
                  label: LocaleKeys.employeeTasksPending.tr(),
                  value: item.pendingTasks,
                  color: const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _TaskMetric(
                  label: LocaleKeys.employeeTasksOverdue.tr(),
                  value: item.overdueTasks,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskMetric extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _TaskMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$value',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color.darken(0.1),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
