import 'package:wafer/core/theme/app_radius.dart';

import '../../../../../core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:wafer/core/utils/widgets/app_toast.dart';

import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../core/theme/app_colors.dart';
import '../cubit/form_data/finance_form_data_cubit.dart';
import '../cubit/form_data/finance_form_data_state.dart';
import '../cubit/payments/create_finance_payment_cubit.dart';
import '../cubit/payments/create_finance_payment_state.dart';
import '../../../../../core/theme/color_utils.dart';

class CreateOwnerPaymentView extends StatefulWidget {
  const CreateOwnerPaymentView({super.key});

  @override
  State<CreateOwnerPaymentView> createState() => _CreateOwnerPaymentViewState();
}

class _CreateOwnerPaymentViewState extends State<CreateOwnerPaymentView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();
  final _payeeIdController = TextEditingController();

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
    _payeeIdController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDebitAccountId == null || _selectedCreditAccountId == null) {
      AppToast.showError(context, LocaleKeys.owner_finance_select_accounts_error.tr());
      return;
    }

    context.read<CreateFinancePaymentCubit>().createPayment(
          payeeId: int.tryParse(_payeeIdController.text) ?? 0,
          amount: num.tryParse(_amountController.text) ?? 0,
          paymentDate: _dateController.text,
          debitAccountId: _selectedDebitAccountId!,
          creditAccountId: _selectedCreditAccountId!,
          propertyId: _selectedPropertyId,
          contractId: _selectedContractId,
          notes: _notesController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateFinancePaymentCubit, CreateFinancePaymentState>(
      listener: (context, state) {
        if (state is CreateFinancePaymentLoading) {
          AppToast.showInfo(context, LocaleKeys.owner_finance_saving.tr());
        } else if (state is CreateFinancePaymentSuccess) {
          AppToast.showSuccess(context, LocaleKeys.owner_finance_save_success.tr());
          context.pop(true);
        } else if (state is CreateFinancePaymentError) {
          AppToast.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leadingWidth: 68,
          leading: const CustomBackButton(),
          title: Text(LocaleKeys.owner_finance_create_payment.tr()),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: _payeeIdController,
                  label: LocaleKeys.owner_finance_payee_id.tr(),
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || val.isEmpty ? 'Ù…Ø·Ù„ÙˆØ¨' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _amountController,
                  label: 'Ø§Ù„Ù…Ø¨Ù„Øº (Amount)',
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || val.isEmpty ? 'Ù…Ø·Ù„ÙˆØ¨' : null,
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
                      label: 'ØªØ§Ø±ÙŠØ® Ø§Ù„Ø³Ù†Ø¯',
                      readOnly: true,
                      validator: (val) => val == null || val.isEmpty ? 'Ù…Ø·Ù„ÙˆØ¨' : null,
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
                          const Text('Ø·Ø±ÙŠÙ‚Ø© Ø§Ù„Ø¯ÙØ¹', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<String>(
                            items: paymentMethods.map((e) => e.value).toList(),
                            value: _selectedPaymentMethod,
                            hint: 'Ø§Ø®ØªØ± Ø·Ø±ÙŠÙ‚Ø© Ø§Ù„Ø¯ÙØ¹',
                            itemLabelBuilder: (val) => paymentMethods.firstWhere((e) => e.value == val).label,
                            onSelected: (val) => setState(() => _selectedPaymentMethod = val),
                          ),
                          const SizedBox(height: 16),
                          const Text('Ø§Ù„Ø­Ø³Ø§Ø¨ Ø§Ù„Ù…Ø¯ÙŠÙ† (Debit Account)', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<int>(
                            items: accounts.map((e) => e.id).toList(),
                            value: _selectedDebitAccountId,
                            hint: 'Ø§Ø®ØªØ± Ø§Ù„Ø­Ø³Ø§Ø¨ Ø§Ù„Ù…Ø¯ÙŠÙ†',
                            itemLabelBuilder: (id) => accounts.firstWhere((e) => e.id == id).nameAr,
                            onSelected: (val) => setState(() => _selectedDebitAccountId = val),
                          ),
                          const SizedBox(height: 16),
                          const Text('Ø§Ù„Ø­Ø³Ø§Ø¨ Ø§Ù„Ø¯Ø§Ø¦Ù† (Credit Account)', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<int>(
                            items: accounts.map((e) => e.id).toList(),
                            value: _selectedCreditAccountId,
                            hint: 'Ø§Ø®ØªØ± Ø§Ù„Ø­Ø³Ø§Ø¨ Ø§Ù„Ø¯Ø§Ø¦Ù†',
                            itemLabelBuilder: (id) => accounts.firstWhere((e) => e.id == id).nameAr,
                            onSelected: (val) => setState(() => _selectedCreditAccountId = val),
                          ),
                          const SizedBox(height: 16),
                          const Text('Ø§Ù„Ø¹Ù‚Ø§Ø± (Property) - Ø§Ø®ØªÙŠØ§Ø±ÙŠ', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<int>(
                            items: properties.map((e) => int.tryParse(e.value) ?? 0).toList(),
                            value: _selectedPropertyId,
                            hint: 'Ø§Ø®ØªØ± Ø§Ù„Ø¹Ù‚Ø§Ø±',
                            itemLabelBuilder: (id) => properties.firstWhere((e) => e.value == id.toString()).label,
                            onSelected: (val) => setState(() => _selectedPropertyId = val),
                          ),
                          const SizedBox(height: 16),
                          const Text('Ø§Ù„Ø¹Ù‚Ø¯ (Contract) - Ø§Ø®ØªÙŠØ§Ø±ÙŠ', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<int>(
                            items: contracts.map((e) => int.tryParse(e.value) ?? 0).toList(),
                            value: _selectedContractId,
                            hint: 'Ø§Ø®ØªØ± Ø§Ù„Ø¹Ù‚Ø¯',
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
                  label: 'Ù…Ù„Ø§Ø­Ø¸Ø§Øª',
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: BlocBuilder<CreateFinancePaymentCubit, CreateFinancePaymentState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
                        ),
                        onPressed: state is CreateFinancePaymentLoading ? null : _submit,
                        child: state is CreateFinancePaymentLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Ø¥Ù†Ø´Ø§Ø¡ Ø§Ù„Ø³Ù†Ø¯', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

