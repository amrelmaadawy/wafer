import 'package:flutter/material.dart';
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
import '../cubit/complete_task/owner_complete_task_cubit.dart';
import '../cubit/complete_task/owner_complete_task_state.dart';

class OwnerCompleteTaskBottomSheet extends StatefulWidget {
  final MaintenanceItemEntity maintenance;
  final dynamic task;

  const OwnerCompleteTaskBottomSheet({
    super.key,
    required this.maintenance,
    required this.task,
  });

  static Future<bool?> show(
    BuildContext context,
    MaintenanceItemEntity maintenance,
    dynamic task,
  ) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<OwnerCompleteTaskCubit>(),
        child: OwnerCompleteTaskBottomSheet(
          maintenance: maintenance,
          task: task,
        ),
      ),
    );
  }

  @override
  State<OwnerCompleteTaskBottomSheet> createState() =>
      _OwnerCompleteTaskBottomSheetState();
}

class _OwnerCompleteTaskBottomSheetState
    extends State<OwnerCompleteTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<OwnerCompleteTaskCubit>().completeTask(
        maintenanceId: widget.maintenance.id ?? 0,
        taskId: widget.task.id ?? 0,
        technicianResponse: _notesController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.task.title ?? '';

    return BlocListener<OwnerCompleteTaskCubit, OwnerCompleteTaskState>(
      listener: (context, state) {
        if (state.status == CompleteTaskStatus.success) {
          context.pop(true);
          AppToast.showSuccess(
            context,
            LocaleKeys.maintenanceTaskCompleteSuccess.tr(),
          );
        } else if (state.status == CompleteTaskStatus.failure) {
          AppToast.showError(
            context,
            state.errorMessage ?? LocaleKeys.maintenanceTaskCompleteError.tr(),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: context.primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      LocaleKeys.maintenanceTaskCompleteTitle.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: AppRadius.circularMd,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.task_alt,
                      color: AppColors.textSecondaryLight,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                LocaleKeys.maintenanceTaskCompleteNotes.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _notesController,
                label: LocaleKeys.maintenanceTaskCompleteNotes.tr(),
                hintText: LocaleKeys.maintenanceTaskCompleteNotesHint.tr(),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return LocaleKeys.maintenanceRequiredField.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              BlocBuilder<OwnerCompleteTaskCubit, OwnerCompleteTaskState>(
                builder: (context, state) {
                  final isLoading = state.status == CompleteTaskStatus.loading;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.circularLg,
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            LocaleKeys.maintenanceTaskCompleteBtn.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
