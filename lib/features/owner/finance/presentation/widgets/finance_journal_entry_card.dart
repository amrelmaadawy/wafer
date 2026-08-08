import 'package:flutter/material.dart';
import 'package:wafer/core/theme/color_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/journal_entries/post_journal_entry_cubit.dart';
import '../cubit/journal_entries/post_journal_entry_state.dart';
import '../cubit/journal_entries/reverse_journal_entry_cubit.dart';
import '../cubit/journal_entries/reverse_journal_entry_state.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
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
      child: Material(
        color: Colors.white,
        borderRadius: AppRadius.circularMd,
        clipBehavior: Clip.antiAlias,
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
                        color: context.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        size: 16,
                        color: context.primaryColor,
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

              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.entry.status.toLowerCase() == 'posted'
                      ? AppColors.success.withValues(alpha: 0.1)
                      : widget.entry.status.toLowerCase() == 'reversed'
                          ? AppColors.error.withValues(alpha: 0.1)
                          : context.primaryColor.withValues(alpha: 0.1),
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
                            : context.primaryColor,
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
                if (widget.entry.status.toLowerCase() == 'draft') ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          context.push(Routes.ownerFinanceUpdateJournalEntry, extra: widget.entry);
                        },
                        borderRadius: AppRadius.circularSm,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: context.primaryColor.withValues(alpha: 0.1),
                            borderRadius: AppRadius.circularSm,
                          ),
                          child: Icon(Icons.edit_rounded, size: 18, color: context.primaryColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      BlocBuilder<PostJournalEntryCubit, PostJournalEntryState>(
                        builder: (context, state) {
                          final isLoading = state is PostJournalEntryLoading && state.entryId == widget.entry.id;
                          return InkWell(
                            onTap: isLoading ? null : () => context.read<PostJournalEntryCubit>().postEntry(widget.entry.id),
                            borderRadius: AppRadius.circularSm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: context.primaryColor,
                                borderRadius: AppRadius.circularSm,
                              ),
                              child: isLoading
                                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : Text(
                                      LocaleKeys.ownerFinancePostJournalEntry.tr(),
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ] else if (widget.entry.status.toLowerCase() == 'posted') ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlocBuilder<ReverseJournalEntryCubit, ReverseJournalEntryState>(
                        builder: (context, state) {
                          final isLoading = state is ReverseJournalEntryLoading && state.journalEntryId == widget.entry.id;
                          return InkWell(
                            onTap: isLoading ? null : () => _showReverseDialog(context),
                            borderRadius: AppRadius.circularSm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: AppRadius.circularSm,
                              ),
                              child: isLoading
                                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : Text(
                                      LocaleKeys.ownerFinanceReverseJournalEntry.tr(),
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
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
    ));
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

  void _showReverseDialog(BuildContext context) {
    final TextEditingController reasonController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.circularXl),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.history_rounded, color: AppColors.error, size: 48),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.ownerFinanceReverseConfirmTitle.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  LocaleKeys.ownerFinanceReverseConfirmMessage.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 14),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: reasonController,
                  label: LocaleKeys.ownerFinanceReverseReason.tr(),
                  hintText: LocaleKeys.ownerFinanceReverseReasonHint.tr(),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return LocaleKeys.ownerFinanceReverseReasonRequired.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: LocaleKeys.ownerFinanceReverseJournalEntry.tr(),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.of(dialogContext).pop();
                            context.read<ReverseJournalEntryCubit>().reverseJournalEntry(
                                  widget.entry.id,
                                  reasonController.text.trim(),
                                );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: LocaleKeys.commonCancel.tr(),
                        type: ButtonType.secondary,
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
