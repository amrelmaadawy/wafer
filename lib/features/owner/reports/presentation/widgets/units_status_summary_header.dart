import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_breakpoints.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/units_status_summary_entity.dart';

class UnitsStatusSummaryHeader extends StatelessWidget {
  final UnitsStatusSummaryEntity summary;
  const UnitsStatusSummaryHeader({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Metric(
        LocaleKeys.reports_unitsStatusTotal.tr(),
        summary.total,
        Icons.domain_rounded,
        context.primaryColor,
      ),
      _Metric(
        LocaleKeys.reports_unitsStatusVacant.tr(),
        summary.vacant,
        Icons.door_front_door_outlined,
        const Color(0xFF10B981),
      ),
      _Metric(
        LocaleKeys.reports_unitsStatusRented.tr(),
        summary.rented,
        Icons.vpn_key_rounded,
        const Color(0xFFF59E0B),
      ),
      _Metric(
        LocaleKeys.reports_unitsStatusMaintenance.tr(),
        summary.maintenance,
        Icons.build_rounded,
        const Color(0xFFEF4444),
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isCompact ? 2 : 4,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        mainAxisExtent: 92,
      ),
      itemBuilder: (_, index) => _MetricCard(metric: items[index]),
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
    padding: const EdgeInsets.all(AppSpacing.sm),
    decoration: BoxDecoration(
      color: context.appSurfaceColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: context.appBorderColor),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: metric.color.withValues(alpha: .1),
            shape: BoxShape.circle,
          ),
          child: Icon(metric.icon, color: metric.color, size: 20),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${metric.value}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              Text(
                metric.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
