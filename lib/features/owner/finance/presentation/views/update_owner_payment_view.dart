import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/theme/app_radius.dart';

import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../domain/entities/payment_entity.dart';
import '../cubit/payments/update_finance_payment_cubit.dart';
import '../cubit/payments/update_finance_payment_state.dart';
import '../cubit/payments/finance_payments_cubit.dart';

class UpdateOwnerPaymentView extends StatefulWidget {
  final PaymentEntity? payment;

  const UpdateOwnerPaymentView({super.key, required this.payment});

  @override
  State<UpdateOwnerPaymentView> createState() => _UpdateOwnerPaymentViewState();
}

class _UpdateOwnerPaymentViewState extends State<UpdateOwnerPaymentView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.payment?.amount.toString() ?? '');
    _dateController = TextEditingController(text: widget.payment?.paymentDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now()));
    _notesController = TextEditingController(text: widget.payment?.notes ?? '');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && widget.payment != null) {
      context.read<UpdateFinancePaymentCubit>().updatePayment(
            paymentId: widget.payment!.id,
            amount: num.tryParse(_amountController.text) ?? 0,
            paymentDate: _dateController.text,
            notes: _notesController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.payment == null) {
      return Scaffold(
        appBar: AppBar(
          leadingWidth: 68,
          leading: const CustomBackButton(),
          title: Text(LocaleKeys.owner_finance_update_payment.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Center(child: Text(LocaleKeys.common_error.tr())),
      );
    }

    return BlocListener<UpdateFinancePaymentCubit, UpdateFinancePaymentState>(
      listener: (context, state) {
        if (state is UpdateFinancePaymentSuccess) {
          AppToast.showSuccess(context, state.message);
          context.read<FinancePaymentsCubit>().fetchPayments(isRefresh: true);
          context.pop();
        } else if (state is UpdateFinancePaymentError) {
          AppToast.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          leadingWidth: 68,
          leading: const CustomBackButton(),
          title: Text(LocaleKeys.owner_finance_update_payment.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  label: LocaleKeys.dashboard_defaultersAmount.tr(),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return LocaleKeys.maintenance_create_required_field.tr();
                    if (num.tryParse(val) == null) return LocaleKeys.maintenance_phone_digits_only.tr();
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
                      label: LocaleKeys.deeds_date.tr(),
                      readOnly: true,
                      validator: (val) => val == null || val.isEmpty ? LocaleKeys.maintenance_create_required_field.tr() : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _notesController,
                  label: LocaleKeys.deeds_notes.tr(),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: BlocBuilder<UpdateFinancePaymentCubit, UpdateFinancePaymentState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
                        ),
                        onPressed: state is UpdateFinancePaymentLoading ? null : _submit,
                        child: state is UpdateFinancePaymentLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                LocaleKeys.owner_finance_account_update_submit.tr(), 
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
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

