import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/theme/app_colors.dart';
import 'package:wafer/core/theme/app_radius.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/unit_full_details_entity.dart';

/// Financial summary card: highlights primary price, shows all payment options.
class UnitPricesSection extends StatelessWidget {
  final UnitFullDetailsEntity unit;

  const UnitPricesSection({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    // Gather all non-zero prices
    final prices = <_Price>[];
    if (unit.monthlyPrice > 0) {
      prices.add(
        _Price(LocaleKeys.unit_details_monthly.tr(), unit.monthlyPrice, true),
      );
    }
    if (unit.perTwoPaymentsPrice > 0) {
      prices.add(
        _Price(
          LocaleKeys.unit_details_per_two_payments.tr(),
          unit.perTwoPaymentsPrice,
          false,
        ),
      );
    }
    if (unit.quarterlyPrice > 0) {
      prices.add(
        _Price(
          LocaleKeys.unit_details_quarterly.tr(),
          unit.quarterlyPrice,
          false,
        ),
      );
    }
    if (prices.isEmpty && unit.rentPrice > 0) {
      prices.add(
        _Price(LocaleKeys.unit_details_rent_prices.tr(), unit.rentPrice, true),
      );
    }

    if (prices.isEmpty) return const SizedBox.shrink();

    final primary = prices.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.unit_details_rent_prices.tr(), style: AppTextStyles.h3),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.circularXxl,
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // â”€â”€ Primary Price â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        color: context.primaryColor,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            primary.label,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _fmt(primary.value),
                                style: AppTextStyles.h2.copyWith(
                                  color: AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Text(
                                  LocaleKeys.commonCurrencySar.tr(),
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.textSecondaryLight,
                                  ),
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

              // â”€â”€ Secondary Prices â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              if (prices.length > 1) ...[
                const Divider(height: 1, color: AppColors.dividerSubtleLight),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      for (var i = 1; i < prices.length; i++) ...[
                        if (i > 1)
                          Container(
                            width: 1,
                            height: 36,
                            color: AppColors.dividerSubtleLight,
                          ),
                        Expanded(child: _buildSecondary(prices[i])),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecondary(_Price p) {
    return Column(
      children: [
        Text(
          p.label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textTertiaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _fmt(p.value),
              style: AppTextStyles.h4.copyWith(color: AppColors.textSecondaryLight),
            ),
            const SizedBox(width: 3),
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Text(
                LocaleKeys.commonCurrencySar.tr(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textTertiaryLight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _fmt(num v) =>
      v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(2);
}

class _Price {
  final String label;
  final num value;
  final bool isPrimary;
  const _Price(this.label, this.value, this.isPrimary);
}


