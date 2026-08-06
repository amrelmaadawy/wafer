import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../cubit/verify_close_maintenance/owner_verify_close_maintenance_cubit.dart';
import '../cubit/verify_close_maintenance/owner_verify_close_maintenance_state.dart';

class OwnerVerifyCloseMaintenanceBottomSheet extends StatefulWidget {
  final MaintenanceItemEntity maintenanceRequest;

  const OwnerVerifyCloseMaintenanceBottomSheet({
    super.key,
    required this.maintenanceRequest,
  });

  @override
  State<OwnerVerifyCloseMaintenanceBottomSheet> createState() =>
      _OwnerVerifyCloseMaintenanceBottomSheetState();
}

class _OwnerVerifyCloseMaintenanceBottomSheetState
    extends State<OwnerVerifyCloseMaintenanceBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _qaCodeController = TextEditingController();
  final _costController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.maintenanceRequest.financials?.actualCost != null) {
      _costController.text = widget.maintenanceRequest.financials!.actualCost
          .toString();
    }
  }

  @override
  void dispose() {
    _qaCodeController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final double actualCost =
          double.tryParse(_costController.text.trim()) ?? 0.0;
      context
          .read<OwnerVerifyCloseMaintenanceCubit>()
          .verifyCloseMaintenanceRequest(
            id: widget.maintenanceRequest.id ?? 0,
            qaCode: _qaCodeController.text.trim(),
            actualCost: actualCost,
            notes: _notesController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      OwnerVerifyCloseMaintenanceCubit,
      OwnerVerifyCloseMaintenanceState
    >(
      listener: (context, state) {
        if (state.status == OwnerVerifyCloseMaintenanceStatus.success) {
          AppToast.showSuccess(
            context,
            LocaleKeys.maintenanceVerifyCloseSuccess.tr(),
          );
          context.pop(true); // Return true to indicate success
        } else if (state.status == OwnerVerifyCloseMaintenanceStatus.failure) {
          AppToast.showError(
            context,
            state.errorMessage ?? LocaleKeys.common_error.tr(),
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state.status == OwnerVerifyCloseMaintenanceStatus.loading;

        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
          ),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      LocaleKeys.maintenanceVerifyCloseTitle.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: _qaCodeController,
                      label: LocaleKeys.maintenanceQaCode.tr(),
                      hintText: LocaleKeys.maintenanceQaCodeHint.tr(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return LocaleKeys.maintenanceRequiredField.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _costController,
                      label: LocaleKeys.maintenanceExecuteCost.tr(),
                      hintText: LocaleKeys.maintenanceExecuteCostHint.tr(),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return LocaleKeys.maintenanceRequiredField.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _notesController,
                      label: LocaleKeys.maintenanceVerifyCloseNotes.tr(),
                      hintText: LocaleKeys.maintenanceExecuteNotesHint.tr(),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return LocaleKeys.maintenanceRequiredField.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.circularMd,
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              LocaleKeys.maintenanceVerifyCloseSubmit.tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
