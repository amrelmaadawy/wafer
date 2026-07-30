import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/utils/widgets/custom_text_field.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

import '../cubit/reject_maintenance/owner_reject_maintenance_cubit.dart';
import '../cubit/reject_maintenance/owner_reject_maintenance_state.dart';

class OwnerRejectMaintenanceBottomSheet extends StatefulWidget {
  final int maintenanceId;

  const OwnerRejectMaintenanceBottomSheet({
    super.key,
    required this.maintenanceId,
  });

  @override
  State<OwnerRejectMaintenanceBottomSheet> createState() =>
      _OwnerRejectMaintenanceBottomSheetState();
}

class _OwnerRejectMaintenanceBottomSheetState
    extends State<OwnerRejectMaintenanceBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Title
              Row(
                children: [
                  Icon(Icons.cancel_outlined, color: AppColors.error, size: 24),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    LocaleKeys.maintenanceRejectRequest.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Supervisor Notes
              CustomTextField(
                controller: _notesController,
                label: LocaleKeys.maintenanceRejectReason.tr(),
                hintText: LocaleKeys.maintenanceRejectReason.tr(),
                maxLines: 4,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return LocaleKeys.maintenanceCreateRequiredField.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              BlocBuilder<
                OwnerRejectMaintenanceCubit,
                OwnerRejectMaintenanceState
              >(
                builder: (context, state) {
                  final isLoading = state is OwnerRejectMaintenanceLoading;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<OwnerRejectMaintenanceCubit>()
                                  .rejectMaintenanceRequest(
                                    id: widget.maintenanceId,
                                    supervisorNotes: _notesController.text,
                                  );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.circularLg,
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            LocaleKeys.maintenanceRejectSubmit.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
