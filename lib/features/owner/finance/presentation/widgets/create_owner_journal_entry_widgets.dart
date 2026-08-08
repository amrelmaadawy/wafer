import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/theme/app_colors.dart';
import 'package:wafer/core/theme/app_radius.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/core/utils/widgets/custom_text_field.dart';
import 'package:wafer/core/presentation/widgets/custom_dropdown_menu.dart';
import '../cubit/form_data/finance_form_data_state.dart';

class JournalLineData {
  final String id = UniqueKey().toString();
  int? accountId;
  final TextEditingController debitController = TextEditingController();
  final TextEditingController creditController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  int? propertyId;
  int? contractId;

  void dispose() {
    debitController.dispose();
    creditController.dispose();
    descriptionController.dispose();
  }
}

class JournalEntryLineWidget extends StatefulWidget {
  final int index;
  final JournalLineData line;
  final FinanceFormDataSuccess state;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const JournalEntryLineWidget({
    super.key,
    required this.index,
    required this.line,
    required this.state,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<JournalEntryLineWidget> createState() => _JournalEntryLineWidgetState();
}

class _JournalEntryLineWidgetState extends State<JournalEntryLineWidget> {
  @override
  Widget build(BuildContext context) {
    final accounts = widget.state.formData.accounts.where((a) => a.isPostable).toList();
    final isArabic = context.locale.languageCode == 'ar';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderLight, width: 1),
        borderRadius: AppRadius.circularLg,
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
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: AppRadius.circularSm,
                    ),
                    child: const Icon(Icons.segment_rounded, size: 16, color: AppColors.textSecondaryLight),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${LocaleKeys.journal_entries_line.tr()} ${widget.index + 1}', 
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimaryLight)
                  ),
                ],
              ),
              if (widget.canRemove)
                InkWell(
                  onTap: widget.onRemove,
                  borderRadius: AppRadius.circularSm,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: AppRadius.circularSm,
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 18),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          CustomDropdownMenu<int>(
            hint: LocaleKeys.owner_finance_account.tr(),
            value: widget.line.accountId,
            items: accounts.map((a) => a.id).toList(),
            itemLabelBuilder: (id) {
              final a = accounts.firstWhere((element) => element.id == id);
              return '${a.code} - ${isArabic ? a.nameAr : a.nameEn}';
            },
            onSelected: (val) {
              setState(() {
                widget.line.accountId = val;
              });
              widget.onChanged();
            },
            errorText: widget.line.accountId == null ? LocaleKeys.owner_finance_account_required.tr() : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: LocaleKeys.journal_entries_debit.tr(),
                  controller: widget.line.debitController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  label: LocaleKeys.journal_entries_credit.tr(),
                  controller: widget.line.creditController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: LocaleKeys.owner_finance_description.tr(),
            controller: widget.line.descriptionController,
          ),
          const SizedBox(height: 12),
          CustomDropdownMenu<int>(
            hint: LocaleKeys.owner_finance_property.tr(),
            value: widget.line.propertyId,
            items: widget.state.formData.properties.map((p) => int.parse(p.value)).toList(),
            itemLabelBuilder: (id) {
              final p = widget.state.formData.properties.firstWhere((element) => element.value == id.toString());
              return p.label;
            },
            onSelected: (val) {
              setState(() {
                widget.line.propertyId = val;
              });
              widget.onChanged();
            },
          ),
          const SizedBox(height: 12),
          CustomDropdownMenu<int>(
            hint: LocaleKeys.owner_finance_contract.tr(),
            value: widget.line.contractId,
            items: widget.state.formData.contracts.map((c) => int.parse(c.value)).toList(),
            itemLabelBuilder: (id) {
              final c = widget.state.formData.contracts.firstWhere((element) => element.value == id.toString());
              return c.label;
            },
            onSelected: (val) {
              setState(() {
                widget.line.contractId = val;
              });
              widget.onChanged();
            },
          ),
        ],
      ),
    );
  }
}

class JournalEntryBottomBarWidget extends StatelessWidget {
  final double totalDebit;
  final double totalCredit;

  const JournalEntryBottomBarWidget({
    super.key,
    required this.totalDebit,
    required this.totalCredit,
  });

  @override
  Widget build(BuildContext context) {
    final isBalanced = (totalDebit - totalCredit).abs() < 0.01;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.05),
                      borderRadius: AppRadius.circularMd,
                      border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LocaleKeys.journal_entries_total_debit.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight)),
                        const SizedBox(height: 4),
                        Text('${totalDebit.toStringAsFixed(2)} ${LocaleKeys.currency_sar.tr()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.success)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.05),
                      borderRadius: AppRadius.circularMd,
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LocaleKeys.journal_entries_total_credit.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight)),
                        const SizedBox(height: 4),
                        Text('${totalCredit.toStringAsFixed(2)} ${LocaleKeys.currency_sar.tr()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.error)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!isBalanced) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Text(
                      LocaleKeys.journal_entries_not_balanced.tr(),
                      style: const TextStyle(color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
