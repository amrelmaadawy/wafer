import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../finance/presentation/cubit/accounts/finance_accounts_cubit.dart';
import '../../../finance/presentation/cubit/accounts/finance_accounts_state.dart';
import '../../../properties/presentation/cubit/list/properties_list_cubit.dart';
import '../../../properties/presentation/cubit/list/properties_list_state.dart';
import '../../../contracts/presentation/cubit/list/owner_contracts_cubit.dart';
import '../../../contracts/presentation/cubit/list/owner_contracts_state.dart';
import '../cubit/receipts/create_finance_receipt_cubit.dart';
import '../cubit/receipts/create_finance_receipt_state.dart';
import '../cubit/receipts/finance_receipts_cubit.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/theme/color_utils.dart';

class CreateOwnerReceiptView extends StatefulWidget {
  const CreateOwnerReceiptView({super.key});

  @override
  State<CreateOwnerReceiptView> createState() => _CreateOwnerReceiptViewState();
}

class _CreateOwnerReceiptViewState extends State<CreateOwnerReceiptView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();
  final _ownerIdController = TextEditingController();

  int? _selectedDebitAccountId;
  int? _selectedCreditAccountId;
  int? _selectedPropertyId;
  String? _selectedContractId;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    context.read<FinanceAccountsCubit>().fetchAccounts(isRefresh: true);
    context.read<PropertiesListCubit>().getProperties(forceRefresh: true);
    context.read<OwnerContractsCubit>().getContracts(forceRefresh: true);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    _ownerIdController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDebitAccountId == null || _selectedCreditAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار الحساب الدائن والمدين')),
      );
      return;
    }

    context.read<CreateFinanceReceiptCubit>().createReceipt(
          ownerId: int.tryParse(_ownerIdController.text) ?? 0,
          amount: num.tryParse(_amountController.text) ?? 0,
          receiptDate: _dateController.text,
          debitAccountId: _selectedDebitAccountId!,
          creditAccountId: _selectedCreditAccountId!,
          propertyId: _selectedPropertyId,
          contractId: _selectedContractId != null ? int.tryParse(_selectedContractId!) : null,
          notes: _notesController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateFinanceReceiptCubit, CreateFinanceReceiptState>(
      listener: (context, state) {
        if (state is CreateFinanceReceiptSuccess) {
          AppToast.showSuccess(context, state.message);
          context.read<FinanceReceiptsCubit>().fetchReceipts(isRefresh: true);
          context.pop();
        } else if (state is CreateFinanceReceiptError) {
          AppToast.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          leadingWidth: 68,
          leading: const CustomBackButton(),
          title: const Text('إنشاء سند مالي'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: _ownerIdController,
                  label: 'رقم المالك (Owner ID)',
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _amountController,
                  label: 'المبلغ (Amount)',
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                GestureDetector(
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
                              onPrimary: Colors.white,
                              onSurface: AppColors.textPrimaryLight,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      _dateController.text = DateFormat('yyyy-MM-dd').format(date);
                    }
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: _dateController,
                      label: 'تاريخ السند',
                      readOnly: true,
                      validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('الحساب المدين (Debit Account)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                BlocBuilder<FinanceAccountsCubit, FinanceAccountsState>(
                  builder: (context, state) {
                    if (state is FinanceAccountsSuccess) {
                      return CustomDropdownMenu<int>(
                        items: state.accounts.map((e) => e.id).toList(),
                        value: _selectedDebitAccountId,
                        hint: 'اختر الحساب المدين',
                        itemLabelBuilder: (id) => state.accounts.firstWhere((e) => e.id == id).nameAr,
                        onSelected: (val) => setState(() => _selectedDebitAccountId = val),
                      );
                    }
                    return AppShimmer.box(height: 56, borderRadius: BorderRadius.circular(12));
                  },
                ),
                const SizedBox(height: 16),
                const Text('الحساب الدائن (Credit Account)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                BlocBuilder<FinanceAccountsCubit, FinanceAccountsState>(
                  builder: (context, state) {
                    if (state is FinanceAccountsSuccess) {
                      return CustomDropdownMenu<int>(
                        items: state.accounts.map((e) => e.id).toList(),
                        value: _selectedCreditAccountId,
                        hint: 'اختر الحساب الدائن',
                        itemLabelBuilder: (id) => state.accounts.firstWhere((e) => e.id == id).nameAr,
                        onSelected: (val) => setState(() => _selectedCreditAccountId = val),
                      );
                    }
                    return AppShimmer.box(height: 56, borderRadius: BorderRadius.circular(12));
                  },
                ),
                const SizedBox(height: 16),
                const Text('العقار (Property) - اختياري', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                BlocBuilder<PropertiesListCubit, PropertiesListState>(
                  builder: (context, state) {
                    if (state is PropertiesListLoaded) {
                      return CustomDropdownMenu<int>(
                        items: state.properties.map((e) => e.id).toList(),
                        value: _selectedPropertyId,
                        hint: 'اختر العقار',
                        itemLabelBuilder: (id) => state.properties.firstWhere((e) => e.id == id).name,
                        onSelected: (val) => setState(() => _selectedPropertyId = val),
                      );
                    }
                    return AppShimmer.box(height: 56, borderRadius: BorderRadius.circular(12));
                  },
                ),
                const SizedBox(height: 16),
                const Text('العقد (Contract) - اختياري', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                BlocBuilder<OwnerContractsCubit, OwnerContractsState>(
                  builder: (context, state) {
                    if (state is OwnerContractsLoaded) {
                      return CustomDropdownMenu<String>(
                        items: state.contracts.map((e) => e.id).toList(),
                        value: _selectedContractId,
                        hint: 'اختر العقد',
                        itemLabelBuilder: (id) => state.contracts.firstWhere((e) => e.id == id).contractNumber,
                        onSelected: (val) => setState(() => _selectedContractId = val),
                      );
                    }
                    return AppShimmer.box(height: 56, borderRadius: BorderRadius.circular(12));
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _notesController,
                  label: 'ملاحظات',
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: BlocBuilder<CreateFinanceReceiptCubit, CreateFinanceReceiptState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: state is CreateFinanceReceiptLoading ? null : _submit,
                        child: state is CreateFinanceReceiptLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('إنشاء السند', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
