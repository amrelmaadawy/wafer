import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../domain/entities/statement_summary_entity.dart';
import '../../domain/entities/client_entity.dart';
import '../../../../../../core/theme/color_utils.dart';

class StatementSummaryCard extends StatelessWidget {
  final StatementSummaryEntity summary;
  final ClientEntity client;

  const StatementSummaryCard({
    super.key,
    required this.summary,
    required this.client,
  });

  Widget _buildSummaryRow(BuildContext context, String label, num value,
      {bool isBold = false}) {
    final bool isNegative = value < 0;
    final Color valueColor = value == 0
        ? context.appOnSurfaceColor
        : (isNegative ? AppColors.error : AppColors.success);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)
                : Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appSecondaryTextColor,
                  ),
          ),
          Text(
            '${value.toStringAsFixed(2)} ر.س',
            textDirection: ui.TextDirection.ltr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isBold ? valueColor : context.appOnSurfaceColor,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: context.primaryColor.withValues(alpha: 0.1),
                child: Text(
                  client.name.isNotEmpty ? client.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: context.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      client.clientTypeLabel ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.appSecondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.appBorderColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSummaryRow(context, LocaleKeys.openingBalance.tr(), summary.openingBalance),
                const SizedBox(height: 8),
                _buildSummaryRow(context, LocaleKeys.totalDebit.tr(), summary.totalDebit),
                const SizedBox(height: 8),
                _buildSummaryRow(context, LocaleKeys.totalCredit.tr(), summary.totalCredit),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.primaryColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.currentBalance.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.primaryColor,
                  ),
                ),
                Text(
                  '${summary.currentBalance.toStringAsFixed(2)} ر.س',
                  textDirection: ui.TextDirection.ltr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
