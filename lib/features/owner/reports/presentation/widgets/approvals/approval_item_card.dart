import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/approvals_report_entity.dart';

class ApprovalItemCard extends StatelessWidget {
  final ApprovalItemEntity item;

  const ApprovalItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(item.status);
    final statusLabel = item.statusLabel ?? item.status;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 18,
                        color: context.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.title != null && item.title!.isNotEmpty
                              ? item.title!
                              : (item.typeLabel ?? item.typeValue ?? '-'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        Icons.account_tree_outlined,
                        item.typeLabel ?? '-',
                      ),
                      const SizedBox(height: 8),
                      if (item.userName != null) ...[
                        _buildInfoRow(Icons.person_outline, item.userName!),
                        const SizedBox(height: 8),
                      ],
                      if (item.date != null)
                        _buildInfoRow(
                          Icons.calendar_today_outlined,
                          item.date!,
                        ),
                    ],
                  ),
                ),
                if (item.amount != null && item.amount!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        LocaleKeys.reports_totalRentValue.tr(),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.amount} ${LocaleKeys.contractsCurrency.tr()}',
                        style: TextStyle(
                          color: context.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
      case 'pending_approval':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
