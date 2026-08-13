import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';

class OwnerFinancialMetric extends StatelessWidget {
  final String label;
  final num amount;
  final Color color;
  final IconData icon;

  const OwnerFinancialMetric({
    super.key,
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final value = amount.toStringAsFixed(amount == amount.toInt() ? 0 : 2);
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(height: AppSpacing.xxs),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              LocaleKeys.commonCurrencySar.tr(args: [value]),
              style: AppTextStyles.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
