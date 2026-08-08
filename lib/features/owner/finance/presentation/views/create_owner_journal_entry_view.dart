import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../domain/entities/create_journal_entry_request_entity.dart';
import '../../domain/entities/update_journal_entry_request_entity.dart';
import '../../domain/entities/journal_entry_entity.dart';
import '../cubit/journal_entries/create_journal_entry_cubit.dart';
import '../cubit/journal_entries/create_journal_entry_state.dart';
import '../cubit/journal_entries/update_journal_entry_cubit.dart';
import '../cubit/journal_entries/update_journal_entry_state.dart';
import '../cubit/form_data/finance_form_data_cubit.dart';
import '../cubit/form_data/finance_form_data_state.dart';
import '../widgets/finance_payments_skeleton.dart';

class _JournalLineData {
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

class CreateOwnerJournalEntryView extends StatefulWidget {
  final JournalEntryEntity? journalEntry;

  const CreateOwnerJournalEntryView({super.key, this.journalEntry});

  @override
  State<CreateOwnerJournalEntryView> createState() => _CreateOwnerJournalEntryViewState();
}

class _CreateOwnerJournalEntryViewState extends State<CreateOwnerJournalEntryView> {
  final _formKey = GlobalKey<FormState>();
  
  final _dateController = TextEditingController();
  final _mainDescriptionController = TextEditingController();
  
  DateTime? _selectedDate;
  
  final List<_JournalLineData> _lines = [];

  @override
  void initState() {
    super.initState();
    context.read<FinanceFormDataCubit>().fetchFormData();
    if (widget.journalEntry != null) {
      _selectedDate = DateTime.tryParse(widget.journalEntry!.entryDate) ?? DateTime.now();
      _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      _mainDescriptionController.text = widget.journalEntry!.description;
      
      for (var line in widget.journalEntry!.lines) {
        final lineData = _JournalLineData();
        lineData.accountId = line.account.id;
        lineData.debitController.text = line.debit > 0 ? line.debit.toString() : '';
        lineData.creditController.text = line.credit > 0 ? line.credit.toString() : '';
        lineData.descriptionController.text = line.description;
        lineData.descriptionController.text = line.description;
        _lines.add(lineData);
      }
    } else {
      _selectedDate = DateTime.now();
      _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      
      // Add two initial lines
      _lines.add(_JournalLineData());
      _lines.add(_JournalLineData());
    }
    
    for (var line in _lines) {
      line.debitController.addListener(_onTotalChanged);
      line.creditController.addListener(_onTotalChanged);
    }
  }

  void _onTotalChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _dateController.dispose();
    _mainDescriptionController.dispose();
    for (var line in _lines) {
      line.dispose();
    }
    super.dispose();
  }

  void _addLine() {
    setState(() {
      final line = _JournalLineData();
      line.debitController.addListener(_onTotalChanged);
      line.creditController.addListener(_onTotalChanged);
      _lines.add(line);
    });
  }

  void _removeLine(int index) {
    if (_lines.length <= 2) {
      AppToast.showError(context, LocaleKeys.journal_entries_min_lines_error.tr());
      return;
    }
    setState(() {
      _lines[index].dispose();
      _lines.removeAt(index);
    });
  }

  double get _totalDebit {
    double total = 0;
    for (var line in _lines) {
      total += double.tryParse(line.debitController.text) ?? 0.0;
    }
    return total;
  }

  double get _totalCredit {
    double total = 0;
    for (var line in _lines) {
      total += double.tryParse(line.creditController.text) ?? 0.0;
    }
    return total;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedDate == null) {
      AppToast.showError(context, LocaleKeys.owner_finance_date_required.tr());
      return;
    }

    final tDebit = _totalDebit;
    final tCredit = _totalCredit;

    if (tDebit <= 0) {
      AppToast.showError(context, LocaleKeys.journal_entries_total_zero_error.tr());
      return;
    }

    if ((tDebit - tCredit).abs() > 0.01) {
      AppToast.showError(context, LocaleKeys.journal_entries_balance_error.tr());
      return;
    }

    List<JournalEntryLineRequestEntity> requestLines = [];
    
    for (int i = 0; i < _lines.length; i++) {
      final line = _lines[i];
      if (line.accountId == null) {
        AppToast.showError(context, '${LocaleKeys.owner_finance_account_required.tr()} (Line ${i + 1})');
        return;
      }
      
      final debit = double.tryParse(line.debitController.text) ?? 0.0;
      final credit = double.tryParse(line.creditController.text) ?? 0.0;
      
      if (debit == 0 && credit == 0) {
        AppToast.showError(context, '${LocaleKeys.journal_entries_line_zero_error.tr()} (Line ${i + 1})');
        return;
      }
      
      if (debit > 0 && credit > 0) {
        AppToast.showError(context, '${LocaleKeys.journal_entries_line_both_error.tr()} (Line ${i + 1})');
        return;
      }

      requestLines.add(JournalEntryLineRequestEntity(
        accountId: line.accountId!,
        debit: debit,
        credit: credit,
        description: line.descriptionController.text,
        projectId: line.propertyId,
        contractId: line.contractId,
      ));
    }

    if (widget.journalEntry != null) {
      final request = UpdateJournalEntryRequestEntity(
        journalEntryId: widget.journalEntry!.id,
        entryDate: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        description: _mainDescriptionController.text,
        lines: requestLines,
      );
      context.read<UpdateJournalEntryCubit>().updateJournalEntry(request);
    } else {
      final request = CreateJournalEntryRequestEntity(
        entryDate: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        description: _mainDescriptionController.text,
        lines: requestLines,
      );
      context.read<CreateJournalEntryCubit>().createJournalEntry(request);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimaryLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: widget.journalEntry != null 
            ? LocaleKeys.owner_finance_update_journal_entry.tr() 
            : LocaleKeys.owner_finance_create_journal_entry.tr(),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CreateJournalEntryCubit, CreateJournalEntryState>(
            listener: (context, state) {
              if (state is CreateJournalEntrySuccess) {
                AppToast.showSuccess(context, LocaleKeys.owner_finance_journal_entry_success.tr());
                context.pop(true);
              } else if (state is CreateJournalEntryError) {
                AppToast.showError(context, state.message);
              }
            },
          ),
          BlocListener<UpdateJournalEntryCubit, UpdateJournalEntryState>(
            listener: (context, state) {
              if (state is UpdateJournalEntrySuccess) {
                AppToast.showSuccess(context, LocaleKeys.owner_finance_update.tr()); // or a better success message
                context.pop(true);
              } else if (state is UpdateJournalEntryError) {
                AppToast.showError(context, state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<FinanceFormDataCubit, FinanceFormDataState>(
          builder: (context, state) {
            if (state is FinanceFormDataLoading) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: FinancePaymentsSkeleton(),
              );
            }
            if (state is FinanceFormDataError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: const TextStyle(color: AppColors.error)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<FinanceFormDataCubit>().fetchFormData(),
                      child: Text(LocaleKeys.owner_finance_retry.tr()),
                    ),
                  ],
                ),
              );
            }
            if (state is FinanceFormDataSuccess) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: AppRadius.circularMd,
                                border: Border.all(color: AppColors.borderLight, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () => _selectDate(context),
                                    child: IgnorePointer(
                                      child: CustomTextField(
                                        label: LocaleKeys.owner_finance_date.tr(),
                                        controller: _dateController,
                                        readOnly: true,
                                        validator: (v) => v == null || v.isEmpty ? LocaleKeys.owner_finance_date_required.tr() : null,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    label: LocaleKeys.owner_finance_description.tr(),
                                    controller: _mainDescriptionController,
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: context.primaryColor.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.list_alt_rounded, size: 18, color: context.primaryColor),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      LocaleKeys.owner_finance_journal_entries.tr(),
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimaryLight),
                                    ),
                                  ],
                                ),
                                FilledButton.icon(
                                  onPressed: _addLine,
                                  icon: const Icon(Icons.add, size: 16),
                                  label: Text(LocaleKeys.owner_finance_add_line.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: context.primaryColor.withValues(alpha: 0.1),
                                    foregroundColor: context.primaryColor,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                    shape: const StadiumBorder(),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            ..._lines.asMap().entries.map((e) {
                              final index = e.key;
                              final line = e.value;
                              return _buildLineItem(index, line, state);
                            }),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildBottomBar(context),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final tDebit = _totalDebit;
    final tCredit = _totalCredit;
    final isBalanced = (tDebit - tCredit).abs() < 0.01;

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
                        Text('${tDebit.toStringAsFixed(2)} ${LocaleKeys.currency_sar.tr()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.success)),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(LocaleKeys.journal_entries_total_credit.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight)),
                        const SizedBox(height: 4),
                        Text('${tCredit.toStringAsFixed(2)} ${LocaleKeys.currency_sar.tr()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.error)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!isBalanced) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularSm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      LocaleKeys.journal_entries_not_balanced.tr(),
                      style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            BlocBuilder<CreateJournalEntryCubit, CreateJournalEntryState>(
              builder: (context, createState) {
                return BlocBuilder<UpdateJournalEntryCubit, UpdateJournalEntryState>(
                  builder: (context, updateState) {
                    final isLoading = createState is CreateJournalEntryLoading || updateState is UpdateJournalEntryLoading;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(borderRadius: AppRadius.circularMd),
                        ),
                        child: isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(
                                widget.journalEntry != null 
                                    ? LocaleKeys.owner_finance_update.tr() 
                                    : LocaleKeys.owner_finance_create.tr(),
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    );
                  }
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItem(int index, _JournalLineData line, FinanceFormDataSuccess state) {
    final accounts = state.formData.accounts.where((a) => a.isPostable).toList();
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
                    '${LocaleKeys.journal_entries_line.tr()} ${index + 1}', 
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimaryLight)
                  ),
                ],
              ),
              if (_lines.length > 2)
                InkWell(
                  onTap: () => _removeLine(index),
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
            value: line.accountId,
            items: accounts.map((a) => a.id).toList(),
            itemLabelBuilder: (id) {
              final a = accounts.firstWhere((element) => element.id == id);
              return '${a.code} - ${isArabic ? a.nameAr : a.nameEn}';
            },
            onSelected: (val) {
              setState(() {
                line.accountId = val;
              });
            },
            errorText: line.accountId == null ? LocaleKeys.owner_finance_account_required.tr() : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: LocaleKeys.journal_entries_debit.tr(),
                  controller: line.debitController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  readOnly: line.creditController.text.isNotEmpty && (double.tryParse(line.creditController.text) ?? 0) > 0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  label: LocaleKeys.journal_entries_credit.tr(),
                  controller: line.creditController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  readOnly: line.debitController.text.isNotEmpty && (double.tryParse(line.debitController.text) ?? 0) > 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: LocaleKeys.owner_finance_description.tr(),
            controller: line.descriptionController,
          ),
          const SizedBox(height: 12),
          CustomDropdownMenu<int>(
            hint: LocaleKeys.owner_finance_property.tr(),
            value: line.propertyId,
            items: state.formData.properties.map((p) => int.parse(p.value)).toList(),
            itemLabelBuilder: (id) {
              final p = state.formData.properties.firstWhere((element) => element.value == id.toString());
              return p.label;
            },
            onSelected: (val) {
              setState(() {
                line.propertyId = val;
              });
            },
          ),
          const SizedBox(height: 12),
          CustomDropdownMenu<int>(
            hint: LocaleKeys.owner_finance_contract.tr(),
            value: line.contractId,
            items: state.formData.contracts.map((c) => int.parse(c.value)).toList(),
            itemLabelBuilder: (id) {
              final c = state.formData.contracts.firstWhere((element) => element.value == id.toString());
              return c.label;
            },
            onSelected: (val) {
              setState(() {
                line.contractId = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
