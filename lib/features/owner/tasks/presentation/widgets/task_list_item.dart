import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/helpers/color_helper.dart';
import '../../../../../core/routing/routes.dart';
import '../../domain/entities/task_entity.dart';
import '../cubits/list/tasks_list_cubit.dart';
import '../cubits/delete/delete_task_cubit.dart';
import '../cubits/delete/delete_task_state.dart';
import 'task_list_item_header.dart';
import 'task_list_item_body.dart';
import 'task_list_item_footer.dart';

class TaskListItem extends StatelessWidget {
  final TaskEntity task;

  const TaskListItem({super.key, required this.task});

  void _onEdit(BuildContext context) async {
    final result = await context.push(Routes.ownerTasksEdit, extra: task);
    if (result == true && context.mounted) {
      context.read<TasksListCubit>().fetchTasks(refresh: true);
    }
  }

  void _showDeleteDialog(BuildContext context) {
    final deleteCubit = sl<DeleteTaskCubit>();
    showDialog(
      context: context,
      builder: (ctx) => BlocConsumer<DeleteTaskCubit, DeleteTaskState>(
        bloc: deleteCubit,
        listener: (context, state) {
          if (state is DeleteTaskSuccess) {
            Navigator.pop(ctx);
            AppToast.showSuccess(context, LocaleKeys.task_deleted_successfully.tr());
            context.read<TasksListCubit>().fetchTasks(refresh: true);
          } else if (state is DeleteTaskError) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is DeleteTaskLoading;
          return Dialog(
            backgroundColor: context.appSurfaceColor,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 40),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    LocaleKeys.delete_task.tr(),
                    style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w800, color: context.appOnSurfaceColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    LocaleKeys.delete_task_confirmation.tr(),
                    style: AppTextStyles.bodyLarge.copyWith(color: context.appSecondaryTextColor, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading ? null : () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: const RoundedRectangleBorder(borderRadius: AppRadius.circularMd),
                            side: BorderSide(color: context.appBorderColor),
                            foregroundColor: context.appSecondaryTextColor,
                          ),
                          child: Text(
                            LocaleKeys.cancel.tr(),
                            style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () => deleteCubit.deleteTask(task.id),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(borderRadius: AppRadius.circularMd),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(
                                  LocaleKeys.delete.tr(),
                                  style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = task.priority != null
        ? ColorHelper.parseHexColor(task.priority!.color, AppColors.primary)
        : context.primaryColor;
    final isOverdue = task.dates?.isOverdue ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final result = await context.push(Routes.ownerTaskDetailsPath(task.id.toString()));
            if (result == true && context.mounted) {
              context.read<TasksListCubit>().fetchTasks(refresh: true);
            }
          },
          borderRadius: AppRadius.circularMd,
          child: Container(
            decoration: BoxDecoration(
              color: context.appSurfaceColor,
              borderRadius: AppRadius.circularMd,
              border: Border.all(
                color: isOverdue
                    ? AppColors.error.withValues(alpha: 0.35)
                    : context.appBorderColor,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaskListItemHeader(task: task, priorityColor: priorityColor),
                TaskListItemBody(task: task, priorityColor: priorityColor, isOverdue: isOverdue),
                TaskListItemFooter(
                  task: task,
                  isOverdue: isOverdue,
                  onEdit: () => _onEdit(context),
                  onDelete: () => _showDeleteDialog(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




