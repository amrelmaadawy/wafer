import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimaryLight.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.borderLight.withValues(alpha: 0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.circularLg,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.circularLg,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header: Amount & Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedAmount,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: context.primaryColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transfer.transferNumber,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: AppRadius.circularMd,
                        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: statusColor),
                          const SizedBox(width: 6),
                          Text(
                            _getLocalizedStatus(transfer.status),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Accounts section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: AppRadius.circularMd,
                    border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.account_balance_wallet_outlined, size: 14, color: AppColors.textSecondaryLight),
                                const SizedBox(width: 4),
                                Text(
                                  LocaleKeys.transfer_from.tr(),
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              transfer.fromAccount?.nameAr ?? '-',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      
                      // Separator Icon
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderLight),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Icon(Icons.arrow_forward_rounded, size: 16, color: context.primaryColor),
                      ),
                      
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.account_balance_outlined, size: 14, color: AppColors.textSecondaryLight),
                                  const SizedBox(width: 4),
                                  Text(
                                    LocaleKeys.transfer_to.tr(),
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                transfer.toAccount?.nameAr ?? '-',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                
                // Footer (Date & Reference)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded, size: 16, color: AppColors.textSecondaryLight),
                        const SizedBox(width: 6),
                        Text(
                          transfer.transferDate,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                    if (transfer.referenceNumber != null && transfer.referenceNumber!.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.tag_rounded, size: 14, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 4),
                          Text(
                            transfer.referenceNumber!,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight),
                          ),
                        ],
                      ),
                  ],
                ),
                
                // Action Buttons
                if (transfer.status.toLowerCase() == 'draft') ...[
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.borderLight, height: 1),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: isApproving ? null : onApprove,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.circularMd),
                      ),
                      child: isApproving
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  LocaleKeys.common_approve.tr(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
