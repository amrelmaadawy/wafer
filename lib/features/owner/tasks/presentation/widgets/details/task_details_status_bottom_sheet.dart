import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/utils/helpers/color_helper.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../cubits/form_data/task_form_data_cubit.dart';
import '../../cubits/form_data/task_form_data_state.dart';
import '../../cubits/update_status/update_task_status_cubit.dart';

class TaskDetailsStatusBottomSheet extends StatelessWidget {
  final TaskFormDataCubit formDataCubit;
  final UpdateTaskStatusCubit updateStatusCubit;
  final int taskId;

  const TaskDetailsStatusBottomSheet({
    super.key,
    required this.formDataCubit,
    required this.updateStatusCubit,
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
          final statuses = state.formData.options.statuses;
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
                      LocaleKeys.status.tr(),
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.appOnSurfaceColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ...statuses.map((statusOption) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          updateStatusCubit.updateStatus(taskId, statusOption.value);
                        },
                        borderRadius: AppRadius.circularMd,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: ColorHelper.parseHexColor(statusOption.color, context.primaryColor).withValues(alpha: 0.1),
                            borderRadius: AppRadius.circularMd,
                            border: Border.all(color: ColorHelper.parseHexColor(statusOption.color, context.primaryColor).withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: ColorHelper.parseHexColor(statusOption.color, context.primaryColor),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Text(
                                  statusOption.label,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ColorHelper.parseHexColor(statusOption.color, context.primaryColor),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: ColorHelper.parseHexColor(statusOption.color, context.primaryColor).withValues(alpha: 0.5),
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



