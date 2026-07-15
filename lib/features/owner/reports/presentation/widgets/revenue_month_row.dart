import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/revenue_entry_entity.dart';

class RevenueMonthRow extends StatelessWidget {
  final RevenueEntryEntity item;

  const RevenueMonthRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final overdue = item.overdue;
    final progress = item.collectionRate.clamp(0.0, 1.0);
    final percentText = (item.collectionRate * 100).toStringAsFixed(0);
    final progressColor = item.collectionRate >= 0.7
        ? const Color(0xFF10B981)
        : item.collectionRate >= 0.4
            ? const Color(0xFFF59E0B)
            : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      borderRadius: AppRadius.circularSm,
                    ),
                    child: Text(
                      _formatMonthLabel(item.month),
                      style: TextStyle(
                        color: context.primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: progressColor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularFull,
                ),
                child: Text(
                  '$percentText%',
                  style: TextStyle(
                    color: progressColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildCell(
                  title: LocaleKeys.revenueExpected.tr(),
                  value: item.expected,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              Expanded(
                child: _buildCell(
                  title: LocaleKeys.revenueCollected.tr(),
                  value: item.collected,
                  color: const Color(0xFF10B981),
                ),
              ),
              Expanded(
                child: _buildCell(
                  title: LocaleKeys.revenueOverdue.tr(),
                  value: overdue,
                  color: overdue > 0
                      ? const Color(0xFFEF4444)
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadius.circularFull,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, val, _) => LinearProgressIndicator(
                      value: val,
                      minHeight: 7,
                      backgroundColor: AppColors.backgroundLight,
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCell({
    required String title,
    required double value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatAmount(value),
          style: TextStyle(
            color: color,
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  /// Converts "2027-06" → "يونيو 2027"
  String _formatMonthLabel(String rawMonth) {
    final parts = rawMonth.split('-');
    if (parts.length < 2) return rawMonth;
    final monthNum = int.tryParse(parts[1]) ?? 0;
    const arabic = [
      '', 'يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    final monthName = (monthNum >= 1 && monthNum <= 12)
        ? arabic[monthNum]
        : parts[1];
    return '$monthName ${parts[0]}';
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k ر.س';
    }
    return '${amount.toStringAsFixed(0)} ر.س';
  }
}
