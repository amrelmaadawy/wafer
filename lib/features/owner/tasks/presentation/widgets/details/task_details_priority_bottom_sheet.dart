import 'package:wafer/core/theme/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/utils/helpers/color_helper.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../cubits/form_data/task_form_data_cubit.dart';
import '../../cubits/form_data/task_form_data_state.dart';
import '../../cubits/update_priority/update_task_priority_cubit.dart';

class TaskDetailsPriorityBottomSheet extends StatelessWidget {
  final TaskFormDataCubit formDataCubit;
  final UpdateTaskPriorityCubit updatePriorityCubit;
  final int taskId;

  const TaskDetailsPriorityBottomSheet({
    super.key,
    required this.formDataCubit,
    required this.updatePriorityCubit,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskFormDataCubit, TaskFormDataState>(
      bloc: formDataCubit,
      builder: (context, state) {
        if (state is TaskFormDataLoading || state is TaskFormDataInitial) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is TaskFormDataError) {
          return SizedBox(
            height: 200,
            child: CustomErrorWidget(
              message: state.message,
              onRetry: () => formDataCubit.fetchFormData(),
            ),
          );
        } else if (state is TaskFormDataLoaded) {
          final priorities = state.formData.options.priorities;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Text(
                      LocaleKeys.update_priority.tr(),
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.appOnSurfaceColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ...priorities.map((priorityOption) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          updatePriorityCubit.updatePriority(taskId, priorityOption.value);
                        },
                        borderRadius: AppRadius.circularMd,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: ColorHelper.parseHexColor(priorityOption.color, context.primaryColor).withValues(alpha: 0.1),
                            borderRadius: AppRadius.circularMd,
                            border: Border.all(color: ColorHelper.parseHexColor(priorityOption.color, context.primaryColor).withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: ColorHelper.parseHexColor(priorityOption.color, context.primaryColor),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Text(
                                  priorityOption.label,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ColorHelper.parseHexColor(priorityOption.color, context.primaryColor),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: ColorHelper.parseHexColor(priorityOption.color, context.primaryColor).withValues(alpha: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}



