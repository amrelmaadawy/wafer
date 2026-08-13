import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/theme/app_radius.dart';
import '../../../../../core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/receipt_entity.dart';
import '../cubit/receipts/update_finance_receipt_cubit.dart';
import '../cubit/receipts/update_finance_receipt_state.dart';
import '../cubit/receipts/finance_receipts_cubit.dart';
import '../../../../../core/utils/widgets/app_toast.dart';

class UpdateOwnerReceiptView extends StatefulWidget {
  final ReceiptEntity? receipt;

  const UpdateOwnerReceiptView({super.key, required this.receipt});

  @override
  State<UpdateOwnerReceiptView> createState() => _UpdateOwnerReceiptViewState();
}

class _UpdateOwnerReceiptViewState extends State<UpdateOwnerReceiptView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.receipt?.amount.toString() ?? '');
    _dateController = TextEditingController(text: widget.receipt?.receiptDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now()));
    _notesController = TextEditingController(text: widget.receipt?.notes ?? '');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && widget.receipt != null) {
      context.read<UpdateFinanceReceiptCubit>().updateReceipt(
            receiptId: widget.receipt!.id,
            amount: num.tryParse(_amountController.text) ?? 0,
            receiptDate: _dateController.text,
            notes: _notesController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.receipt == null) {
      return Scaffold(
        appBar: AppBar(
          leadingWidth: 68,
          leading: const CustomBackButton(),
          title: Text(LocaleKeys.owner_finance_update_receipt.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Center(child: Text(LocaleKeys.owner_finance_receipt_not_found.tr())),
      );
    }

    return BlocListener<UpdateFinanceReceiptCubit, UpdateFinanceReceiptState>(
      listener: (context, state) {
        if (state is UpdateFinanceReceiptSuccess) {
          AppToast.showSuccess(context, state.message);
          context.read<FinanceReceiptsCubit>().fetchReceipts(isRefresh: true);
          context.pop();
        } else if (state is UpdateFinanceReceiptError) {
          AppToast.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          leadingWidth: 68,
          leading: const CustomBackButton(),
          title: Text(LocaleKeys.owner_finance_update_receipt.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: _amountController,
                  label: LocaleKeys.owner_finance_amount_label.tr(),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Ù…Ø·Ù„ÙˆØ¨'; // Will fix required translation soon
                    if (num.tryParse(val) == null) return LocaleKeys.owner_finance_invalid_value.tr();
                    return null;
                  },
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
                      label: LocaleKeys.owner_finance_receipt_date.tr(),
                      readOnly: true,
                      validator: (val) => val == null || val.isEmpty ? 'Ù…Ø·Ù„ÙˆØ¨' : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _notesController,
                  label: LocaleKeys.owner_finance_notes_label.tr(),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: BlocBuilder<UpdateFinanceReceiptCubit, UpdateFinanceReceiptState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
                        ),
                        onPressed: state is UpdateFinanceReceiptLoading ? null : _submit,
                        child: state is UpdateFinanceReceiptLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(LocaleKeys.owner_finance_save_changes.tr(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
