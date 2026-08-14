import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_breakpoints.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/employee_tasks_summary_entity.dart';

class EmployeeTasksSummaryHeader extends StatelessWidget {
  final EmployeeTasksSummaryEntity summary;
  const EmployeeTasksSummaryHeader({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _Metric(
        LocaleKeys.employeeTasksTotalEmployees.tr(),
        summary.totalEmployees,
        Icons.groups_2_outlined,
        Theme.of(context).colorScheme.primary,
      ),
      _Metric(
        LocaleKeys.employeeTasksTotalCompleted.tr(),
        summary.totalCompleted,
        Icons.task_alt_rounded,
        const Color(0xFF10B981),
      ),
      _Metric(
        LocaleKeys.employeeTasksTotalPending.tr(),
        summary.totalPending,
        Icons.pending_actions_rounded,
        const Color(0xFFF59E0B),
      ),
      _Metric(
        LocaleKeys.employeeTasksTotalOverdue.tr(),
        summary.totalOverdue,
        Icons.warning_amber_rounded,
        const Color(0xFFEF4444),
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isCompact ? 2 : 4,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        mainAxisExtent: 106,
      ),
      itemBuilder: (_, index) => _MetricCard(metric: metrics[index]),
    );
  }
}

class _Metric {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  const _Metric(this.label, this.value, this.icon, this.color);
}

class _MetricCard extends StatelessWidget {
  final _Metric metric;
  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: context.appSurfaceColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: context.primaryShadow.withValues(alpha: 0.06),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: metric.color.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(metric.icon, color: metric.color, size: 24),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${metric.value}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, height: 1.2),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                metric.label,
                maxLines: 2,
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
  );
}
