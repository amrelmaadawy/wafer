import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../cubit/forward_maintenance/owner_forward_maintenance_cubit.dart';
import '../cubit/forward_maintenance/owner_forward_maintenance_state.dart';

class OwnerForwardMaintenanceBottomSheet extends StatefulWidget {
  final int maintenanceId;

  const OwnerForwardMaintenanceBottomSheet({
    super.key,
    required this.maintenanceId,
  });

  @override
  State<OwnerForwardMaintenanceBottomSheet> createState() =>
      _OwnerForwardMaintenanceBottomSheetState();
}

class _OwnerForwardMaintenanceBottomSheetState
    extends State<OwnerForwardMaintenanceBottomSheet> {
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
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.maintenanceForwardTitle.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomTextField(
                controller: _notesController,
                label: LocaleKeys.maintenanceForwardNotes.tr(),
                hintText: LocaleKeys.maintenanceForwardNotes.tr(),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),
              BlocConsumer<
                OwnerForwardMaintenanceCubit,
                OwnerForwardMaintenanceState
              >(
                listener: (context, state) {
                  if (state is OwnerForwardMaintenanceSuccess) {
                    AppToast.showSuccess(context, state.message);
                    context.pop(true);
                  } else if (state is OwnerForwardMaintenanceError) {
                    AppToast.showError(context, state.message);
                  }
                },
                builder: (context, state) {
                  final isLoading = state is OwnerForwardMaintenanceLoading;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<OwnerForwardMaintenanceCubit>()
                                  .forwardMaintenanceRequest(
                                    id: widget.maintenanceId,
                                    notes: _notesController.text.trim(),
                                  );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryColor,
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
                            LocaleKeys.maintenanceForwardBtn.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
