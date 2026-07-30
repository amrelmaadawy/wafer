import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../cubit/approve_maintenance/owner_approve_maintenance_cubit.dart';
import '../cubit/approve_maintenance/owner_approve_maintenance_state.dart';

class OwnerApproveMaintenanceBottomSheet extends StatefulWidget {
  final int maintenanceId;

  const OwnerApproveMaintenanceBottomSheet({
    super.key,
    required this.maintenanceId,
  });

  @override
  State<OwnerApproveMaintenanceBottomSheet> createState() =>
      _OwnerApproveMaintenanceBottomSheetState();
}

class _OwnerApproveMaintenanceBottomSheetState
    extends State<OwnerApproveMaintenanceBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _estimatedCostController = TextEditingController();
  final _advancePaymentController = TextEditingController();
  final _notesController = TextEditingController();
  String _costBearer = 'owner';

  @override
  void dispose() {
    _estimatedCostController.dispose();
    _advancePaymentController.dispose();
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
                LocaleKeys.maintenanceApproveConfirmTitle.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Cost Bearer
              CustomDropdownMenu<String>(
                value: _costBearer,
                hint: LocaleKeys.maintenanceCostBearerLabel.tr(),
                items: const ['owner', 'client'],
                itemLabelBuilder: (val) => val == 'owner'
                    ? LocaleKeys.maintenanceCostBearerOwner.tr()
                    : LocaleKeys.maintenanceCostBearerClient.tr(),
                onSelected: (val) {
                  setState(() => _costBearer = val);
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Estimated Cost
              CustomTextField(
                controller: _estimatedCostController,
                label: LocaleKeys.maintenanceEstimatedCost.tr(),
                hintText: LocaleKeys.maintenanceEstimatedCost.tr(),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return LocaleKeys.maintenanceCreateRequiredField.tr();
                  }
                  if (num.tryParse(val) == null) {
                    return LocaleKeys.maintenancePhoneDigitsOnly
                        .tr(); // Reusing digits error or generic
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Advance Payment
              CustomTextField(
                controller: _advancePaymentController,
                label: LocaleKeys.maintenanceAdvancePayment.tr(),
                hintText: LocaleKeys.maintenanceAdvancePayment.tr(),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Supervisor Notes
              CustomTextField(
                controller: _notesController,
                label: LocaleKeys.maintenanceSupervisorNotes.tr(),
                hintText: LocaleKeys.maintenanceSupervisorNotes.tr(),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              BlocBuilder<
                OwnerApproveMaintenanceCubit,
                OwnerApproveMaintenanceState
              >(
                builder: (context, state) {
                  final isLoading = state is OwnerApproveMaintenanceLoading;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<OwnerApproveMaintenanceCubit>()
                                  .approveMaintenanceRequest(
                                    id: widget.maintenanceId,
                                    estimatedCost: num.parse(
                                      _estimatedCostController.text,
                                    ),
                                    advancePayment:
                                        _advancePaymentController
                                            .text
                                            .isNotEmpty
                                        ? num.tryParse(
                                            _advancePaymentController.text,
                                          )
                                        : null,
                                    costBearer: _costBearer,
                                    supervisorNotes: _notesController.text,
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
                            LocaleKeys.maintenanceApproveSubmit.tr(),
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
