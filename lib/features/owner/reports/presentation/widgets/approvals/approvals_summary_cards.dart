import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../domain/entities/approvals_report_entity.dart';

class ApprovalsSummaryCards extends StatelessWidget {
  final ApprovalsSummaryEntity summary;

  const ApprovalsSummaryCards({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _Card(
                title: LocaleKeys.ownerReportsTotalApprovals.tr(),
                value: summary.total.toString(),
                icon: Icons.list_alt,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _Card(
                title: LocaleKeys.ownerReportsApproved.tr(),
                value: summary.approved.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _Card(
                title: LocaleKeys.ownerReportsPending.tr(),
                value: summary.pending.toString(),
                icon: Icons.pending_actions,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _Card(
                title: LocaleKeys.ownerReportsRejected.tr(),
                value: summary.rejected.toString(),
                icon: Icons.cancel,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _Card({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
