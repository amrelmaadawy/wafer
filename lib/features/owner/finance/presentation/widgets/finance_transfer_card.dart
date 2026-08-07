import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../domain/entities/transfer_entity.dart';

class FinanceTransferCard extends StatelessWidget {
  final TransferEntity transfer;
  final VoidCallback? onTap;
  final VoidCallback? onApprove;
  final bool isApproving;

  const FinanceTransferCard({
    super.key,
    required this.transfer,
    this.onTap,
    this.onApprove,
    this.isApproving = false,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'approved':
      case 'posted':
        return AppColors.success;
      case 'draft':
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
      case 'rejected':
      case 'failed':
        return AppColors.error;
      default:
        return AppColors.textSecondaryLight;
    }
  }

  String _getLocalizedStatus(String status) {
    // Assuming backend returns these common statuses or similar
    // Map them to localized keys or just return capitalized if no translation exists
    switch (status.toLowerCase()) {
      case 'completed':
      case 'posted':
        return LocaleKeys.owner_finance_update_payment_success.tr(); // fallback to generic success/posted
      case 'draft':
        return LocaleKeys.owner_reports_pending.tr();
      case 'pending':
        return LocaleKeys.owner_reports_pending.tr();
      case 'cancelled':
        return LocaleKeys.owner_finance_cancel_payment.tr();
      default:
        return status.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(transfer.status);
    final valueString = NumberFormat("#,##0.00", "en_US").format(transfer.amount);
    final formattedAmount = LocaleKeys.common_currency_sar.tr(args: [valueString]);

    return Material(
      color: AppColors.surfaceLight,
      borderRadius: AppRadius.circularLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circularLg,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderLight),
            borderRadius: AppRadius.circularLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Transfer Number & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transfer.transferNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: AppRadius.circularSm,
                    ),
                    child: Text(
                      _getLocalizedStatus(transfer.status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Amount
              Text(
                formattedAmount,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),

              // From & To Accounts
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.transfer_from.tr(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transfer.fromAccount?.nameAr ?? '-',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.textSecondaryLight,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.transfer_to.tr(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transfer.toAccount?.nameAr ?? '-',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(color: AppColors.borderLight, height: 1),
              const SizedBox(height: 12),

              // Date & Reference
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        transfer.transferDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  if (transfer.referenceNumber != null &&
                      transfer.referenceNumber!.isNotEmpty)
                    Text(
                      'Ref: ${transfer.referenceNumber}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                ],
              ),
              if (transfer.status.toLowerCase() == 'draft') ...[
                const SizedBox(height: 12),
                const Divider(color: AppColors.borderLight, height: 1),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: isApproving ? null : onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.circularSm,
                      ),
                    ),
                    child: isApproving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            LocaleKeys.common_approve.tr(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
