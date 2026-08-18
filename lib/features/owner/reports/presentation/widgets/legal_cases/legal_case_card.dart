import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/legal_cases_report_entity.dart';

class LegalCaseCard extends StatelessWidget {
  final LegalCaseItemEntity item;

  const LegalCaseCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.gavel, size: 20, color: context.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.legalCases_caseNumber.tr(),
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.caseNumber,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: _getStatusColor(item.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailRow(
                        Icons.person_outline,
                        LocaleKeys.legalCases_plaintiff.tr(),
                        item.plaintiff ?? '-',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDetailRow(
                        Icons.person_off_outlined,
                        LocaleKeys.legalCases_defendant.tr(),
                        item.defendant ?? '-',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  Icons.account_balance_outlined,
                  LocaleKeys.legalCases_court.tr(),
                  item.court ?? '-',
                ),
                if (item.propertyName != null || item.unitName != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    Icons.business_outlined,
                    LocaleKeys.property.tr(),
                    '${item.propertyName ?? ''} ${item.unitName != null ? ' - ${item.unitName}' : ''}',
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (item.hearingDate != null)
                      Expanded(
                        child: _buildDetailRow(
                          Icons.calendar_today_outlined,
                          LocaleKeys.legalCases_hearingDate.tr(),
                          item.hearingDate!,
                        ),
                      ),
                    if (item.nextHearingDate != null) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDetailRow(
                          Icons.event_outlined,
                          LocaleKeys.legalCases_nextHearingDate.tr(),
                          item.nextHearingDate!,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    if (status.contains('تم حل') || status.contains('محلول')) {
      return Colors.green;
    } else if (status.contains('مرفوض') || status.contains('موقوف')) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }
}
