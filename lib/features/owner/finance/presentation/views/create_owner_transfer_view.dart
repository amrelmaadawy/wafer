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
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../domain/entities/create_transfer_request_entity.dart';
import '../../domain/entities/transfer_entity.dart';
import '../../domain/usecases/update_transfer_use_case.dart';
import '../cubit/transfers/create_transfer_cubit.dart';
import '../cubit/transfers/update_transfer_cubit.dart';
import '../cubit/transfers/update_transfer_state.dart';
import '../cubit/form_data/finance_form_data_cubit.dart';
import '../cubit/form_data/finance_form_data_state.dart';

class CreateOwnerTransferView extends StatefulWidget {
  final TransferEntity? transfer;
  const CreateOwnerTransferView({super.key, this.transfer});

  @override
  State<CreateOwnerTransferView> createState() => _CreateOwnerTransferViewState();
}

class _CreateOwnerTransferViewState extends State<CreateOwnerTransferView> {
  final _formKey = GlobalKey<FormState>();
  
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _selectedDate;
  int? _fromAccountId;
  int? _toAccountId;

  @override
  void initState() {
    super.initState();
    context.read<FinanceFormDataCubit>().fetchFormData();
    if (widget.transfer != null) {
      final t = widget.transfer!;
      _amountController.text = t.amount.toString();
      _referenceController.text = t.referenceNumber ?? '';
      _notesController.text = t.notes ?? '';
      _selectedDate = DateTime.tryParse(t.transferDate);
      _fromAccountId = t.fromAccount?.id;
      _toAccountId = t.toAccount?.id;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedDate == null) {
      AppToast.showError(context, LocaleKeys.ownerFinanceTransferDateRequired.tr());
      return;
    }
    if (_fromAccountId == null) {
      AppToast.showError(context, 'Please select From Account');
      return;
    }
    if (_toAccountId == null) {
      AppToast.showError(context, 'Please select To Account');
      return;
    }
    
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) {
      AppToast.showError(context, 'Invalid amount');
      return;
    }

    if (widget.transfer != null) {
      final request = UpdateTransferParams(
        transferId: widget.transfer!.id,
        transferDate: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        amount: amount,
        fromAccountId: _fromAccountId!,
        toAccountId: _toAccountId!,
        referenceNumber: _referenceController.text,
        notes: _notesController.text,
      );
      context.read<UpdateTransferCubit>().updateTransfer(request);
    } else {
      final request = CreateTransferRequestEntity(
        transferDate: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        amount: amount,
        fromAccountId: _fromAccountId!,
        toAccountId: _toAccountId!,
        referenceNumber: _referenceController.text,
        notes: _notesController.text,
      );
      context.read<CreateTransferCubit>().createTransfer(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: widget.transfer != null 
            ? 'تعديل التحويل المالي' // Can be localized later
            : LocaleKeys.owner_finance_internal_transfers.tr(),
      ),
      body: MultiBlocListener(
        listeners: [
          if (widget.transfer == null)
            BlocListener<CreateTransferCubit, CreateTransferState>(
              listener: (context, state) {
                if (state is CreateTransferSuccess) {
                  AppToast.showSuccess(context, LocaleKeys.owner_finance_transfer_success.tr());
                  context.pop(true);
                } else if (state is CreateTransferError) {
                  AppToast.showError(context, state.message);
                }
              },
            ),
          if (widget.transfer != null)
            BlocListener<UpdateTransferCubit, UpdateTransferState>(
              listener: (context, state) {
                if (state is UpdateTransferSuccess) {
                  AppToast.showSuccess(context, LocaleKeys.owner_finance_transfer_success.tr());
                  context.pop(true);
                } else if (state is UpdateTransferError) {
                  AppToast.showError(context, state.message);
                }
              },
            ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transfer Date
                Text(
                  LocaleKeys.reports_contractStart.tr(), // Using as generic Date label for now
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: context.primaryColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      setState(() => _selectedDate = date);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderLight),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Text(
                      _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : LocaleKeys.select_date.tr(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Amount
                CustomTextField(
                  controller: _amountController,
                  label: LocaleKeys.owner_reports_amount.tr(),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required field';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // From Account
                Text(
                  LocaleKeys.transfer_from.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                BlocBuilder<FinanceFormDataCubit, FinanceFormDataState>(
                  builder: (context, state) {
                    if (state is FinanceFormDataLoading) {
                      return AppShimmer.box(height: 48, borderRadius: BorderRadius.circular(8));
                    }
                    if (state is FinanceFormDataSuccess) {
                      final accounts = state.formData.accounts.where((a) => a.isPostable).toList();
                      return CustomDropdownMenu<int>(
                        value: _fromAccountId,
                        items: accounts.map((e) => e.id).toList(),
                        itemLabelBuilder: (val) {
                          final index = accounts.indexWhere((e) => e.id == val);
                          if (index == -1) return '';
                          final acc = accounts[index];
                          return context.locale.languageCode == 'ar' ? acc.nameAr : acc.nameEn;
                        },
                        hint: LocaleKeys.transfer_from.tr(),
                        onSelected: (val) => setState(() => _fromAccountId = val),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 16),

                // To Account
                Text(
                  LocaleKeys.transfer_to.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                BlocBuilder<FinanceFormDataCubit, FinanceFormDataState>(
                  builder: (context, state) {
                    if (state is FinanceFormDataLoading) {
                      return AppShimmer.box(height: 48, borderRadius: BorderRadius.circular(8));
                    }
                    if (state is FinanceFormDataSuccess) {
                      final accounts = state.formData.accounts.where((a) => a.isPostable).toList();
                      return CustomDropdownMenu<int>(
                        value: _toAccountId,
                        items: accounts.map((e) => e.id).toList(),
                        itemLabelBuilder: (val) {
                          final index = accounts.indexWhere((e) => e.id == val);
                          if (index == -1) return '';
                          final acc = accounts[index];
                          return context.locale.languageCode == 'ar' ? acc.nameAr : acc.nameEn;
                        },
                        hint: LocaleKeys.transfer_to.tr(),
                        onSelected: (val) => setState(() => _toAccountId = val),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 16),

                // Reference Number
                CustomTextField(
                  controller: _referenceController,
                  label: 'الرقم المرجعي (Reference) - اختياري',
                ),
                const SizedBox(height: 16),

                // Notes
                CustomTextField(
                  controller: _notesController,
                  label: LocaleKeys.owner_finance_notes.tr(),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: widget.transfer != null
                      ? BlocBuilder<UpdateTransferCubit, UpdateTransferState>(
                          builder: (context, state) {
                            final isLoading = state is UpdateTransferLoading;
                            return _buildSubmitBtn(isLoading);
                          },
                        )
                      : BlocBuilder<CreateTransferCubit, CreateTransferState>(
                          builder: (context, state) {
                            final isLoading = state is CreateTransferLoading;
                            return _buildSubmitBtn(isLoading);
                          },
                        ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitBtn(bool isLoading) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: context.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: isLoading ? null : _submit,
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              widget.transfer != null ? LocaleKeys.common_edit.tr() : LocaleKeys.common_save.tr(),
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }
}
