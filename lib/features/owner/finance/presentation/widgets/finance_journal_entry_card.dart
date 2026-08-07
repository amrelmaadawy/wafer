import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../domain/entities/journal_entry_entity.dart';

class FinanceJournalEntryCard extends StatefulWidget {
  final JournalEntryEntity entry;

  const FinanceJournalEntryCard({
    super.key,
    required this.entry,
  });

  @override
  State<FinanceJournalEntryCard> createState() => _FinanceJournalEntryCardState();
}

class _FinanceJournalEntryCardState extends State<FinanceJournalEntryCard> {
  String _getLocalizedStatus(String status) {
    if (status.toLowerCase() == 'posted') return LocaleKeys.journal_entries_status_posted.tr();
    if (status.toLowerCase() == 'reversed') return LocaleKeys.journal_entries_status_reversed.tr();
    return status.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularMd,
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.entry.entryNumber,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.entry.status.toLowerCase() == 'draft')
                IconButton(
                  icon: const Icon(Icons.edit_rounded, size: 20, color: AppColors.primary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    context.push(Routes.ownerFinanceUpdateJournalEntry, extra: widget.entry);
                  },
                ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.entry.status.toLowerCase() == 'posted'
                      ? AppColors.success.withValues(alpha: 0.1)
                      : widget.entry.status.toLowerCase() == 'reversed'
                          ? AppColors.error.withValues(alpha: 0.1)
                          : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getLocalizedStatus(widget.entry.status),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: widget.entry.status.toLowerCase() == 'posted'
                        ? AppColors.success
                        : widget.entry.status.toLowerCase() == 'reversed'
                            ? AppColors.error
                            : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.entry.description.isNotEmpty) ...[
                  Text(
                    widget.entry.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondaryLight,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.entry.entryDate,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: AppRadius.circularSm,
                        border: Border.all(color: AppColors.borderLight, width: 0.5),
                      ),
                      child: Text(
                        '${widget.entry.totalDebit.toStringAsFixed(2)} ${LocaleKeys.currency_sar.tr()}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          children: [
            const Divider(color: AppColors.borderLight, height: 1),
            const SizedBox(height: 12),
            ...widget.entry.lines.map((line) => _buildLineItem(line)),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItem(JournalEntryLineEntity line) {
    final bool isDebit = line.debit > 0;
    final amount = isDebit ? line.debit : line.credit;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.circularMd,
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDebit 
                  ? AppColors.success.withValues(alpha: 0.1) 
                  : AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDebit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              size: 18,
              color: isDebit ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.locale.languageCode == 'ar' 
                      ? line.account.nameAr 
                      : line.account.nameEn,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                if (line.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    line.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondaryLight,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${amount.toStringAsFixed(2)} ${LocaleKeys.currency_sar.tr()}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDebit 
                      ? AppColors.success.withValues(alpha: 0.1) 
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularSm,
                ),
                child: Text(
                  isDebit ? LocaleKeys.journal_entries_debit.tr() : LocaleKeys.journal_entries_credit.tr(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isDebit ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
