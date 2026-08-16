import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../domain/entities/unified_transaction_entity.dart';

class UnifiedTransactionCard extends StatelessWidget {
  final UnifiedTransactionEntity transaction;
  final VoidCallback? onTap;

  const UnifiedTransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isPositive;
    final amountColor = isIncome ? AppColors.success : AppColors.error;
    final prefix = isIncome ? '+' : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.circularLg,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildTypeIcon(context),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.referenceNumber,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            transaction.partyName ?? _getTypeLabel(transaction.type),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$prefix${transaction.amount.toStringAsFixed(2)} ${LocaleKeys.owner_finance_currency_sar.tr()}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: amountColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildStatusBadge(context),
                      ],
                    ),
                  ],
                ),
                if (transaction.propertyName != null || transaction.unitName != null) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.borderLight),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.apartment_rounded,
                        size: 14,
                        color: AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          [
                            if (transaction.propertyName != null) transaction.propertyName,
                            if (transaction.unitName != null) transaction.unitName,
                          ].join(' - '),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondaryLight,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (transaction.date.isNotEmpty)
                        Text(
                          transaction.date,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondaryLight,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon(BuildContext context) {
    IconData icon;
    Color color;

    switch (transaction.type) {
      case UnifiedTransactionType.receipt:
        icon = Icons.arrow_downward_rounded;
        color = AppColors.success;
        break;
      case UnifiedTransactionType.payment:
        icon = Icons.arrow_upward_rounded;
        color = AppColors.error;
        break;
      case UnifiedTransactionType.transfer:
        icon = Icons.swap_horiz_rounded;
        color = AppColors.primary;
        break;
      case UnifiedTransactionType.adjustment:
        icon = Icons.tune_rounded;
        color = AppColors.warning;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final status = transaction.status.toLowerCase();
    Color bg = AppColors.info.withValues(alpha: 0.1);
    Color fg = AppColors.info;

    if (status == 'paid' || status == 'approved' || status == 'completed') {
      bg = AppColors.success.withValues(alpha: 0.1);
      fg = AppColors.success;
    } else if (status == 'cancelled' || status == 'rejected') {
      bg = AppColors.error.withValues(alpha: 0.1);
      fg = AppColors.error;
    } else if (status == 'pending' || status == 'draft') {
      bg = AppColors.warning.withValues(alpha: 0.1);
      fg = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.circularFull,
      ),
      child: Text(
        transaction.status,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getTypeLabel(UnifiedTransactionType type) {
    switch (type) {
      case UnifiedTransactionType.receipt:
        return LocaleKeys.financeTransactionsReceipts.tr();
      case UnifiedTransactionType.payment:
        return LocaleKeys.financeTransactionsPayments.tr();
      case UnifiedTransactionType.transfer:
        return LocaleKeys.financeTransactionsTransfers.tr();
      case UnifiedTransactionType.adjustment:
        return LocaleKeys.financeTransactionsAdjustments.tr();
    }
  }
}
