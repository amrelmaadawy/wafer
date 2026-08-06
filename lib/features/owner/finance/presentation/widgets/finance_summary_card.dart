import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/finance_overview_entity.dart';

class FinanceSummaryCardWidget extends StatelessWidget {
  final FinanceSummaryEntity summary;

  const FinanceSummaryCardWidget({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final isPositiveFlow = summary.netCashFlow >= 0;
    final flowColor = isPositiveFlow ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.owner_finance_net_cash_flow.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimaryLight.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                isPositiveFlow
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: flowColor,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 8),
          _AnimatedCurrencyText(
            value: summary.netCashFlow,
            color: context.primaryColor,
            fontSize: 36,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildSubTotal(
                  context,
                  title: LocaleKeys.owner_finance_receipts_total.tr(),
                  value: summary.receiptsTotal,
                  color: AppColors.success,
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.borderLight,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildSubTotal(
                  context,
                  title: LocaleKeys.owner_finance_payments_total.tr(),
                  value: summary.paymentsTotal,
                  color: AppColors.error,
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubTotal(
    BuildContext context, {
    required String title,
    required double value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: color),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
          const SizedBox(height: 12),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: _AnimatedCurrencyText(
            value: value,
            color: AppColors.textPrimaryLight,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class _AnimatedCurrencyText extends StatelessWidget {
  final double value;
  final Color color;
  final double fontSize;

  const _AnimatedCurrencyText({
    required this.value,
    required this.color,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutQuart,
      builder: (context, animValue, child) {
        return Text(
          '${animValue.toStringAsFixed(2)} ${LocaleKeys.common_currency_sar.tr(args: ['']).trim()}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
            fontSize: fontSize,
          ),
        );
      },
    );
  }
}
