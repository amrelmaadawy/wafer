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
import '../cubit/execute_maintenance/owner_execute_maintenance_cubit.dart';
import '../cubit/execute_maintenance/owner_execute_maintenance_state.dart';

class OwnerExecuteMaintenanceBottomSheet extends StatefulWidget {
  final MaintenanceItemEntity maintenanceRequest;

  const OwnerExecuteMaintenanceBottomSheet({
    super.key,
    required this.maintenanceRequest,
  });

  @override
  State<OwnerExecuteMaintenanceBottomSheet> createState() =>
      _OwnerExecuteMaintenanceBottomSheetState();
}

class _OwnerExecuteMaintenanceBottomSheetState
    extends State<OwnerExecuteMaintenanceBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _costController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final double actualCost =
          double.tryParse(_costController.text.trim()) ?? 0.0;
      context.read<OwnerExecuteMaintenanceCubit>().executeMaintenanceRequest(
        id: widget.maintenanceRequest.id ?? 0,
        technicianResponse: _notesController.text.trim(),
        actualCost: actualCost,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      OwnerExecuteMaintenanceCubit,
      OwnerExecuteMaintenanceState
    >(
      listener: (context, state) {
        if (state.status == OwnerExecuteMaintenanceStatus.success) {
          AppToast.showSuccess(
            context,
            LocaleKeys.maintenanceExecuteSuccess.tr(),
          );
          context.pop(
            state.responseEntity,
          ); // Return response to show QA Dialog
        } else if (state.status == OwnerExecuteMaintenanceStatus.failure) {
          AppToast.showError(
            context,
            state.errorMessage ?? LocaleKeys.common_error.tr(),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == OwnerExecuteMaintenanceStatus.loading;

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
                      LocaleKeys.maintenanceExecuteConfirmTitle.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: _notesController,
                      label: LocaleKeys.maintenanceExecuteNotes.tr(),
                      hintText: LocaleKeys.maintenanceExecuteNotesHint.tr(),
                      maxLines: 3,
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
                              LocaleKeys.maintenanceExecuteSubmit.tr(),
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
