import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../generated/locale_keys.dart';
import '../../domain/entities/receipt_entity.dart';

class FinanceReceiptCard extends StatelessWidget {
  final ReceiptEntity receipt;
  final VoidCallback? onTap;

  const FinanceReceiptCard({
    super.key,
    required this.receipt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isConfirmed = receipt.status == 'confirmed';
    final statusColor = isConfirmed ? AppColors.success : AppColors.error;
    final statusText = isConfirmed
        ? LocaleKeys.profile_active.tr() // Might need specific translation like "مؤكد"
        : LocaleKeys.profile_inactive.tr(); // Might need specific translation like "ملغى"

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXl,
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimaryLight.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Receipt Number & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.1),
                        borderRadius: AppRadius.circularLg,
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: AppColors.primaryLight,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      receipt.receiptNumber,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: AppFonts.fontFamilyEn,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                _buildStatusBadge(context, statusText, statusColor),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.borderLight),
            const SizedBox(height: 16),

            // Middle Row: Amount & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.amount.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${receipt.amount} ر.س',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.fontFamilyEn,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      LocaleKeys.deeds_date.tr(), // or receipt_date
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      receipt.receiptDate,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.fontFamilyEn,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Bottom Row: Owner Name & Payment Method
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: AppColors.textSecondaryLight,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      receipt.owner.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: AppRadius.circularMd,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.payments_outlined,
                        size: 14,
                        color: AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        receipt.paymentMethod.label,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.textSecondaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularXl,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
