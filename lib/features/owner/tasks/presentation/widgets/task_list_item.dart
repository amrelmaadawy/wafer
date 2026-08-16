import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/theme/app_colors.dart';
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

import '../../../../../core/presentation/widgets/app_confirm_dialog.dart';

class TaskListItem extends StatelessWidget {
  final TaskEntity task;

  const TaskListItem({super.key, required this.task});

  void _onEdit(BuildContext context) async {
    final result = await context.push(Routes.ownerTasksEdit, extra: task);
    if (result == true && context.mounted) {
      context.read<TasksListCubit>().fetchTasks(refresh: true);
    }
  }

  void _showDeleteDialog(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      titleKey: LocaleKeys.delete_task,
      messageKey: LocaleKeys.delete_task_confirmation,
      impactKey: LocaleKeys.commonActionCannotBeUndone,
      isDangerous: true,
    );

    if (confirmed == true && context.mounted) {
      final deleteCubit = sl<DeleteTaskCubit>();
      final tasksListCubit = context.read<TasksListCubit>();

      deleteCubit.stream.listen((state) {
        if (!context.mounted) return;
        if (state is DeleteTaskSuccess) {
          AppToast.showSuccess(context, LocaleKeys.task_deleted_successfully.tr());
          tasksListCubit.fetchTasks(refresh: true);
        } else if (state is DeleteTaskError) {
          AppToast.showError(context, state.message);
        }
      });
      deleteCubit.deleteTask(task.id);
    }
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




