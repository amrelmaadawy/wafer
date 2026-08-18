import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../domain/entities/legal_cases_report_entity.dart';

class LegalCasesSummaryCards extends StatelessWidget {
  final LegalCasesSummaryEntity summary;

  const LegalCasesSummaryCards({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: LocaleKeys.reports_total.tr(),
            value: summary.total.toString(),
            icon: Icons.gavel_rounded,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            title: LocaleKeys.reports_active.tr(),
            value: summary.active.toString(),
            icon: Icons.pending_actions,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            title: LocaleKeys.reports_resolved.tr(),
            value: summary.resolved.toString(),
            icon: Icons.check_circle_outline,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
