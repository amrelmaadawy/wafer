import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wafer/core/theme/app_radius.dart';
import 'package:wafer/core/utils/widgets/app_toast.dart';

import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../core/theme/app_colors.dart';
import '../cubit/form_data/finance_form_data_cubit.dart';
import '../cubit/form_data/finance_form_data_state.dart';
import '../cubit/receipts/create_finance_receipt_cubit.dart';
import '../cubit/receipts/create_finance_receipt_state.dart';
import '../cubit/receipts/finance_receipts_cubit.dart';
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

  int? _selectedOwnerId;

  int? _selectedDebitAccountId;
  int? _selectedCreditAccountId;
  int? _selectedPropertyId;
  int? _selectedContractId;
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    context.read<FinanceFormDataCubit>().fetchFormData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDebitAccountId == null || _selectedCreditAccountId == null) {
      AppToast.showError(context, LocaleKeys.owner_finance_select_accounts_error.tr());
      return;
    }

    context.read<CreateFinanceReceiptCubit>().createReceipt(
          ownerId: _selectedOwnerId ?? 0,
          amount: num.tryParse(_amountController.text) ?? 0,
          receiptDate: _dateController.text,
          debitAccountId: _selectedDebitAccountId!,
          creditAccountId: _selectedCreditAccountId!,
          propertyId: _selectedPropertyId,
          contractId: _selectedContractId,
          notes: _notesController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateFinanceReceiptCubit, CreateFinanceReceiptState>(
      listener: (context, state) {
        if (state is CreateFinanceReceiptLoading) {
          AppToast.showInfo(context, LocaleKeys.financeSaving.tr());
        } else if (state is CreateFinanceReceiptSuccess) {
          AppToast.showSuccess(context, LocaleKeys.financeReceiptSaved.tr());
          context.read<FinanceReceiptsCubit>().fetchReceipts(isRefresh: true);
          context.pop();
        } else if (state is CreateFinanceReceiptError) {
          AppToast.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leadingWidth: 68,
          leading: const CustomBackButton(),
          title: Text(LocaleKeys.financeCreateReceipt.tr()),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<FinanceFormDataCubit, FinanceFormDataState>(
                  builder: (context, state) {
                    if (state is FinanceFormDataSuccess) {
                      final users = state.formData.users;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(LocaleKeys.financeOwnerId.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<int>(
                            items: users.map((e) => int.tryParse(e.value) ?? 0).toList(),
                            value: _selectedOwnerId,
                            hint: LocaleKeys.financeOwnerId.tr(),
                            itemLabelBuilder: (id) => users.firstWhere((e) => e.value == id.toString()).label,
                            onSelected: (val) => setState(() => _selectedOwnerId = val),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _amountController,
                  label: LocaleKeys.financeAmount.tr(),
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || val.isEmpty ? LocaleKeys.financeRequired.tr() : null,
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
                      label: LocaleKeys.financeDate.tr(),
                      readOnly: true,
                      validator: (val) => val == null || val.isEmpty ? LocaleKeys.financeRequired.tr() : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<FinanceFormDataCubit, FinanceFormDataState>(
                  builder: (context, state) {
                    if (state is FinanceFormDataSuccess) {
                      final accounts = state.formData.accounts;
                      final properties = state.formData.properties;
                      final contracts = state.formData.contracts;
                      final paymentMethods = state.formData.paymentMethods;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(LocaleKeys.financePaymentMethod.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<String>(
                            items: paymentMethods.map((e) => e.value).toList(),
                            value: _selectedPaymentMethod,
                            hint: LocaleKeys.financeSelectPaymentMethod.tr(),
                            itemLabelBuilder: (val) => paymentMethods.firstWhere((e) => e.value == val).label,
                            onSelected: (val) => setState(() => _selectedPaymentMethod = val),
                          ),
                          const SizedBox(height: 16),
                          Text(LocaleKeys.financeDebitAccount.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<int>(
                            items: accounts.map((e) => e.id).toList(),
                            value: _selectedDebitAccountId,
                            hint: LocaleKeys.financeSelectDebit.tr(),
                            itemLabelBuilder: (id) => accounts.firstWhere((e) => e.id == id).nameAr,
                            onSelected: (val) => setState(() => _selectedDebitAccountId = val),
                          ),
                          const SizedBox(height: 16),
                          Text(LocaleKeys.financeCreditAccount.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<int>(
                            items: accounts.map((e) => e.id).toList(),
                            value: _selectedCreditAccountId,
                            hint: LocaleKeys.financeSelectCredit.tr(),
                            itemLabelBuilder: (id) => accounts.firstWhere((e) => e.id == id).nameAr,
                            onSelected: (val) => setState(() => _selectedCreditAccountId = val),
                          ),
                          const SizedBox(height: 16),
                          Text(LocaleKeys.financePropertyOptional.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<int>(
                            items: properties.map((e) => int.tryParse(e.value) ?? 0).toList(),
                            value: _selectedPropertyId,
                            hint: LocaleKeys.financeSelectProperty.tr(),
                            itemLabelBuilder: (id) => properties.firstWhere((e) => e.value == id.toString()).label,
                            onSelected: (val) => setState(() => _selectedPropertyId = val),
                          ),
                          const SizedBox(height: 16),
                          Text(LocaleKeys.financeContractOptional.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<int>(
                            items: contracts.map((e) => int.tryParse(e.value) ?? 0).toList(),
                            value: _selectedContractId,
                            hint: LocaleKeys.financeSelectContract.tr(),
                            itemLabelBuilder: (id) => contracts.firstWhere((e) => e.value == id.toString()).label,
                            onSelected: (val) => setState(() => _selectedContractId = val),
                          ),
                        ],
                      );
                    } else if (state is FinanceFormDataError) {
                      return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                    }
                    return AppShimmer.box(height: 250, borderRadius: AppRadius.circularLg);
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _notesController,
                  label: LocaleKeys.financeNotes.tr(),
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
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
                        ),
                        onPressed: state is CreateFinanceReceiptLoading ? null : _submit,
                        child: state is CreateFinanceReceiptLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(LocaleKeys.financeCreateAction.tr(), style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

