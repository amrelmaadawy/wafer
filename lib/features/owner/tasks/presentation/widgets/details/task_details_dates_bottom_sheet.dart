import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../../../domain/entities/task_entity.dart';
import '../../cubits/update_dates/update_task_dates_cubit.dart';
import '../../cubits/update_dates/update_task_dates_state.dart';

class TaskDetailsDatesBottomSheet extends StatefulWidget {
  final UpdateTaskDatesCubit updateDatesCubit;
  final int taskId;
  final TaskDatesEntity currentDates;

  const TaskDetailsDatesBottomSheet({
    super.key,
    required this.updateDatesCubit,
    required this.taskId,
    required this.currentDates,
  });

  @override
  State<TaskDetailsDatesBottomSheet> createState() => _TaskDetailsDatesBottomSheetState();
}

class _TaskDetailsDatesBottomSheetState extends State<TaskDetailsDatesBottomSheet> {
  String? selectedStartDate;
  String? selectedDueDate;

  @override
  void initState() {
    super.initState();
    selectedStartDate = widget.currentDates.startDate;
    selectedDueDate = widget.currentDates.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            LocaleKeys.update_dates.tr(),
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
              color: context.appOnSurfaceColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          CustomTextField(
            label: LocaleKeys.contractsStartDateLabel.tr(),
            hintText: 'yyyy-MM-dd',
            readOnly: true,
            controller: TextEditingController(text: selectedStartDate),
            prefixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedStartDate != null ? DateTime.tryParse(selectedStartDate!) ?? DateTime.now() : DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Theme.of(context).primaryColor,
                        onPrimary: Colors.white,
                        surface: context.appSurfaceColor,
                        onSurface: context.appOnSurfaceColor,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) {
                setState(() {
                  selectedStartDate = DateFormat('yyyy-MM-dd').format(date);
                });
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            label: LocaleKeys.maintenanceDueDate.tr(),
            hintText: 'yyyy-MM-dd',
            readOnly: true,
            controller: TextEditingController(text: selectedDueDate),
            prefixIcon: const Icon(Icons.event_rounded, size: 20),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDueDate != null ? DateTime.tryParse(selectedDueDate!) ?? DateTime.now() : DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Theme.of(context).primaryColor,
                        onPrimary: Colors.white,
                        surface: context.appSurfaceColor,
                        onSurface: context.appOnSurfaceColor,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) {
                setState(() {
                  selectedDueDate = DateFormat('yyyy-MM-dd').format(date);
                });
              }
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          BlocBuilder<UpdateTaskDatesCubit, UpdateTaskDatesState>(
            bloc: widget.updateDatesCubit,
            builder: (context, state) {
              return CustomButton(
                text: LocaleKeys.save.tr(),
                isLoading: state is UpdateTaskDatesLoading,
                onPressed: () {
                  if (selectedStartDate == null || selectedStartDate!.isEmpty) {
                    AppToast.showError(context, LocaleKeys.start_date_required.tr());
                    return;
                  }
                  if (selectedDueDate == null || selectedDueDate!.isEmpty) {
                    AppToast.showError(context, LocaleKeys.due_date_required.tr());
                    return;
                  }
                  widget.updateDatesCubit.updateDates(
                    widget.taskId,
                    startDate: selectedStartDate,
                    dueDate: selectedDueDate,
                  );
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}


