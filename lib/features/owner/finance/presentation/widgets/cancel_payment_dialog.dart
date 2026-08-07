import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';

class CancelPaymentDialog extends StatefulWidget {
  final Function(String) onConfirm;

  const CancelPaymentDialog({super.key, required this.onConfirm});

  @override
  State<CancelPaymentDialog> createState() => _CancelPaymentDialogState();
}

class _CancelPaymentDialogState extends State<CancelPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.circularXl),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.cancel_outlined, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.ownerFinanceCancelPayment.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.fontFamilyAr,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                LocaleKeys.ownerFinanceCancelPaymentConfirmation.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 14),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _reasonController,
                label: LocaleKeys.ownerFinanceCancelReasonLabel.tr(),
                hintText: LocaleKeys.ownerFinanceCancelReasonHint.tr(),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return LocaleKeys.ownerFinanceCancelReasonError.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: LocaleKeys.ownerFinanceCancelPayment.tr(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).pop();
                          widget.onConfirm(_reasonController.text.trim());
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: LocaleKeys.propertyCreateExitTitle.tr(), // 'تراجع' or similar standard cancel key
                      type: ButtonType.secondary,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
