import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/contract_installments_summary_entity.dart';

class InstallmentsSummaryCard extends StatelessWidget {
  final ContractInstallmentsSummaryEntity summary;

  const InstallmentsSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor,
            context.primaryColor.withValues(alpha: 0.78),
          ],
        ),
        borderRadius: AppRadius.circularXxl,
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  LocaleKeys.installmentsTitle.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${summary.paidCount} / ${summary.installmentsCount}',
                style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _SummaryMetric(
                label: LocaleKeys.installmentsTotalAmount.tr(),
                value: summary.totalAmount,
                color: Colors.white,
              ),
              _SummaryMetric(
                label: LocaleKeys.installmentsPaidAmount.tr(),
                value: summary.paidAmount,
                color: Colors.white,
              ),
              _SummaryMetric(
                label: LocaleKeys.installmentsRemainingAmount.tr(),
                value: summary.remainingAmount,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadius.circularFull,
            child: LinearProgressIndicator(
              value: summary.paidProgress,
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value.toStringAsFixed(0),
            style: AppTextStyles.h4.copyWith(color: color),
          ),
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
