import 'package:flutter/material.dart';
import 'package:wafer/core/theme/color_utils.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../generated/locale_keys.dart';
import '../../domain/entities/receipt_entity.dart';

class FinanceReceiptCard extends StatelessWidget {
  final ReceiptEntity receipt;
  final VoidCallback? onTap;
  final VoidCallback? onEditTap;

  const FinanceReceiptCard({
    super.key,
    required this.receipt,
    this.onTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final isConfirmed = receipt.status == 'confirmed';
    final statusColor = isConfirmed ? AppColors.success : AppColors.error;
    final statusText = isConfirmed
        ? LocaleKeys.profile_active.tr()
        : LocaleKeys.profile_inactive.tr();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.circularXl,
          boxShadow: [
            BoxShadow(
              color: context.primaryColor.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppRadius.circularXl,
          child: Stack(
            children: [
              // Left Accent Border
              Positioned(
                left: context.locale.languageCode == 'ar' ? null : 0,
                right: context.locale.languageCode == 'ar' ? 0 : null,
                top: 0,
                bottom: 0,
                child: Container(width: 4, color: statusColor),
              ),
              
              // Watermark Icon
              Positioned(
                right: context.locale.languageCode == 'ar' ? null : -20,
                left: context.locale.languageCode == 'ar' ? -20 : null,
                bottom: -20,
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: 120,
                  color: context.primaryColor.withValues(alpha: 0.03),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Number and Actions
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                context.primaryColor.withValues(alpha: 0.15),
                                context.primaryColor.withValues(alpha: 0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: AppRadius.circularLg,
                          ),
                          child: Icon(Icons.receipt_long_rounded, color: context.primaryColor, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                receipt.receiptNumber,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontFamily: AppFonts.fontFamilyEn,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimaryLight,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                receipt.receiptDate,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontFamily: AppFonts.fontFamilyEn,
                                      color: AppColors.textSecondaryLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (onEditTap != null && receipt.status != 'cancelled') ...[
                          GestureDetector(
                            onTap: onEditTap,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.borderLight, width: 1.5),
                              ),
                              child: Icon(Icons.edit_rounded, size: 16, color: context.primaryColor),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Amount Section
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: AppRadius.circularLg,
                        border: Border.all(color: AppColors.borderLight, width: 0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.amount.tr(),
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppColors.textSecondaryLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${receipt.amount}',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          color: context.primaryColor,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: AppFonts.fontFamilyEn,
                                          letterSpacing: -0.5,
                                        ),
                                  ),
                                  const SizedBox(width: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      'ر.س',
                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                            color: context.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          _buildStatusBadge(context, statusText, statusColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Footer: Owner & Method
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.textSecondaryLight.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person_rounded, size: 14, color: AppColors.textSecondaryLight),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              receipt.owner.name,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textPrimaryLight,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppRadius.circularMd,
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.account_balance_wallet_rounded, size: 14, color: AppColors.textSecondaryLight),
                              const SizedBox(width: 6),
                              Text(
                                receipt.paymentMethod.label,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppColors.textSecondaryLight,
                                      fontWeight: FontWeight.w700,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

