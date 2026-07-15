import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/revenue_entry_entity.dart';

class RevenueAnimatedBarChart extends StatelessWidget {
  final List<RevenueEntryEntity> entries;

  const RevenueAnimatedBarChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    double maxVal = 100.0;
    for (final e in entries) {
      if (e.expected > maxVal) maxVal = e.expected;
      if (e.collected > maxVal) maxVal = e.collected;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.revenueBarChartTitle.tr(),
                style: const TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              _buildLegend(context),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 190,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: entries
                    .map((item) => _buildMonthBarGroup(context, item, maxVal))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      children: [
        _legendItem(context.primaryColor, LocaleKeys.revenueExpected.tr()),
        const SizedBox(width: 12),
        _legendItem(const Color(0xFF10B981), LocaleKeys.revenueCollected.tr()),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthBarGroup(
      BuildContext context, RevenueEntryEntity item, double maxVal) {
    final expectedRatio = (item.expected / maxVal).clamp(0.02, 1.0);
    final collectedRatio = (item.collected / maxVal).clamp(0.02, 1.0);
    final formattedMonth = _formatMonth(item.month);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 145,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _singleBar(
                  heightRatio: expectedRatio,
                  color: context.primaryColor,
                  value: item.expected,
                ),
                const SizedBox(width: 5),
                _singleBar(
                  heightRatio: collectedRatio,
                  color: const Color(0xFF10B981),
                  value: item.collected,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formattedMonth,
            style: const TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _singleBar({
    required double heightRatio,
    required Color color,
    required double value,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: value),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, animVal, _) {
            final labelStr = animVal >= 1000
                ? '${(animVal / 1000).toStringAsFixed(1)}k'
                : animVal.toStringAsFixed(0);
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                labelStr,
                style: TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          },
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 120 * heightRatio),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutQuart,
              builder: (context, val, _) {
                return Container(
                  width: 16,
                  height: val,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  /// Converts "2027-06" to "يونيو 27" / "Jun 27"
  String _formatMonth(String rawMonth) {
    final parts = rawMonth.split('-');
    if (parts.length < 2) return rawMonth;
    final monthNum = int.tryParse(parts[1]) ?? 0;
    final year = parts[0].length >= 4 ? parts[0].substring(2) : parts[0];
    const arabic = [
      '', 'يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    final monthName = (monthNum >= 1 && monthNum <= 12)
        ? arabic[monthNum]
        : rawMonth;
    return '$monthName\n$year';
  }
}
