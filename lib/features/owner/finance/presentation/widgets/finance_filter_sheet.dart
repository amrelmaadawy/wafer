import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/unified_transactions_query_entity.dart';

class FinanceFilterSheet extends StatefulWidget {
  final UnifiedTransactionsQueryEntity initialQuery;
  final ValueChanged<UnifiedTransactionsQueryEntity> onApply;

  const FinanceFilterSheet({
    super.key,
    required this.initialQuery,
    required this.onApply,
  });

  @override
  State<FinanceFilterSheet> createState() => _FinanceFilterSheetState();
}

class _FinanceFilterSheetState extends State<FinanceFilterSheet> {
  late String? _selectedType;
  late String? _selectedStatus;
  late TextEditingController _dateFromController;
  late TextEditingController _dateToController;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialQuery.type ?? 'all';
    _selectedStatus = widget.initialQuery.status;
    _dateFromController = TextEditingController(text: widget.initialQuery.dateFrom ?? '');
    _dateToController = TextEditingController(text: widget.initialQuery.dateTo ?? '');
  }

  @override
  void dispose() {
    _dateFromController.dispose();
    _dateToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.financeTransactionsFilters.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondaryLight),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.financeType.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildTypeChip('all', LocaleKeys.financeTransactionsAll.tr()),
              _buildTypeChip('receipt', LocaleKeys.financeTransactionsReceipts.tr()),
              _buildTypeChip('payment', LocaleKeys.financeTransactionsPayments.tr()),
              _buildTypeChip('transfer', LocaleKeys.financeTransactionsTransfers.tr()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _dateFromController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.financeTransactionsDateFrom.tr(),
                    hintText: 'YYYY-MM-DD',
                    prefixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                    border: OutlineInputBorder(borderRadius: AppRadius.circularMd),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _dateToController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.financeTransactionsDateTo.tr(),
                    hintText: 'YYYY-MM-DD',
                    prefixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                    border: OutlineInputBorder(borderRadius: AppRadius.circularMd),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedType = 'all';
                      _selectedStatus = null;
                      _dateFromController.clear();
                      _dateToController.clear();
                    });
                  },
                  child: Text(LocaleKeys.financeResetFilter.tr()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final updatedQuery = widget.initialQuery.copyWith(
                      type: _selectedType,
                      status: _selectedStatus,
                      dateFrom: _dateFromController.text.trim().isEmpty ? null : _dateFromController.text.trim(),
                      dateTo: _dateToController.text.trim().isEmpty ? null : _dateToController.text.trim(),
                    );
                    widget.onApply(updatedQuery);
                    Navigator.pop(context);
                  },
                  child: Text(LocaleKeys.financeApplyFilter.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String typeValue, String label) {
    final isSelected = _selectedType == typeValue;
    final primary = context.primaryColor;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: isSelected ? primary : AppColors.textSecondaryLight,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) setState(() => _selectedType = typeValue);
      },
    );
  }
}
