import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../domain/entities/statement_transaction_entity.dart';

class StatementTransactionCard extends StatelessWidget {
  final StatementTransactionEntity transaction;

  const StatementTransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isDebit = transaction.debit > 0;
    final num amount = isDebit ? transaction.debit : transaction.credit;
    final Color amountColor =
        isDebit ? AppColors.error : AppColors.success;
    final IconData icon =
        isDebit ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppSurfaceCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: amountColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: amountColor, size: 24),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.transactionTypeLabel ??
                              LocaleKeys.transactionType.tr(),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transaction.description ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.appSecondaryTextColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${isDebit ? '-' : '+'}${amount.toStringAsFixed(2)}',
                    textDirection: ui.TextDirection.ltr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: amountColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: context.appBorderColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (transaction.reference != null) ...[
                        Text(
                          '${LocaleKeys.transactionReference.tr()}: ${transaction.reference}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: context.appSecondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        _formatDate(transaction.date),
                        textDirection: ui.TextDirection.ltr,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.appSecondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${LocaleKeys.currentBalance.tr()}: ${transaction.balance.toStringAsFixed(2)}',
                      textDirection: ui.TextDirection.ltr,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
