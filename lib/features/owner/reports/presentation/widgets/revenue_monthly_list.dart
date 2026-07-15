import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/revenue_entry_entity.dart';
import 'revenue_month_row.dart';

class RevenueMonthlyList extends StatelessWidget {
  final List<RevenueEntryEntity> entries;

  const RevenueMonthlyList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month_rounded,
                size: 18, color: AppColors.textPrimaryLight),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.revenueMonthlyBreakdown.tr(),
              style: const TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...entries.map((item) => RevenueMonthRow(item: item)),
      ],
    );
  }
}
