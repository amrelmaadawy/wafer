import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
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
        border: Border.all(color: context.appBorderColor),
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
              const SizedBox(width: AppSpacing.sm),
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
                    Text(
                      item.phone.isNotEmpty ? item.phone : item.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
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
              Expanded(
                child: _TaskMetric(
                  label: LocaleKeys.employeeTasksPending.tr(),
                  value: item.pendingTasks,
                  color: const Color(0xFFF59E0B),
                ),
              ),
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
  Widget build(BuildContext context) => Column(
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
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}
