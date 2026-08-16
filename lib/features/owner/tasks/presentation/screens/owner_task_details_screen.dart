import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/helpers/color_helper.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/routing/routes.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/task_entity.dart';
import '../cubits/details/task_details_cubit.dart';
import '../cubits/details/task_details_state.dart';
import '../widgets/task_details_widgets.dart';
import '../cubits/delete/delete_task_cubit.dart';
import '../cubits/delete/delete_task_state.dart';
import '../cubits/form_data/task_form_data_cubit.dart';
import '../cubits/update_status/update_task_status_cubit.dart';
import '../cubits/update_status/update_task_status_state.dart';
import '../cubits/update_progress/update_task_progress_cubit.dart';
import '../cubits/update_progress/update_task_progress_state.dart';
import '../cubits/update_priority/update_task_priority_cubit.dart';
import '../cubits/update_priority/update_task_priority_state.dart';
import '../cubits/update_dates/update_task_dates_cubit.dart';
import '../cubits/update_dates/update_task_dates_state.dart';
import '../cubits/add_comment/add_task_comment_cubit.dart';
import '../cubits/add_comment/add_task_comment_state.dart';
import '../cubits/add_assignee/add_task_assignee_cubit.dart';
import '../cubits/add_assignee/add_task_assignee_state.dart';
import '../cubits/remove_assignee/remove_task_assignee_cubit.dart';
import '../cubits/remove_assignee/remove_task_assignee_state.dart';
import '../widgets/task_comments_section.dart';
import '../widgets/details/task_details_status_bottom_sheet.dart';
import '../widgets/details/task_details_progress_bottom_sheet.dart';
import '../widgets/details/task_details_priority_bottom_sheet.dart';
import '../widgets/details/task_details_dates_bottom_sheet.dart';
import '../widgets/task_assignees_section.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/custom_button.dart';

class OwnerTaskDetailsScreen extends StatefulWidget {
  final int taskId;

  const OwnerTaskDetailsScreen({super.key, required this.taskId});

  @override
  State<OwnerTaskDetailsScreen> createState() => _OwnerTaskDetailsScreenState();
}

class _OwnerTaskDetailsScreenState extends State<OwnerTaskDetailsScreen> {
  late final TaskDetailsCubit _cubit;
  late final DeleteTaskCubit _deleteCubit;
  late final TaskFormDataCubit _formDataCubit;
  late final UpdateTaskStatusCubit _updateStatusCubit;
  late final UpdateTaskProgressCubit _updateProgressCubit;
  late final UpdateTaskPriorityCubit _updatePriorityCubit;
  late final UpdateTaskDatesCubit _updateDatesCubit;
  late final AddTaskCommentCubit _addCommentCubit;
  late final AddTaskAssigneeCubit _addAssigneeCubit;
  late final RemoveTaskAssigneeCubit _removeAssigneeCubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<TaskDetailsCubit>()..fetchTaskDetails(widget.taskId);
    _deleteCubit = sl<DeleteTaskCubit>();
    _formDataCubit = sl<TaskFormDataCubit>()..fetchFormData();
    _updateStatusCubit = sl<UpdateTaskStatusCubit>();
    _updateProgressCubit = sl<UpdateTaskProgressCubit>();
    _updatePriorityCubit = sl<UpdateTaskPriorityCubit>();
    _updateDatesCubit = sl<UpdateTaskDatesCubit>();
    _addCommentCubit = sl<AddTaskCommentCubit>();
    _addAssigneeCubit = sl<AddTaskAssigneeCubit>();
    _removeAssigneeCubit = sl<RemoveTaskAssigneeCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    _deleteCubit.close();
    _formDataCubit.close();
    _updateStatusCubit.close();
    _updateProgressCubit.close();
    _updatePriorityCubit.close();
    _updateDatesCubit.close();
    _addCommentCubit.close();
    _addAssigneeCubit.close();
    _removeAssigneeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _deleteCubit),
        BlocProvider.value(value: _formDataCubit),
        BlocProvider.value(value: _updateStatusCubit),
        BlocProvider.value(value: _updateProgressCubit),
        BlocProvider.value(value: _updatePriorityCubit),
        BlocProvider.value(value: _updateDatesCubit),
        BlocProvider.value(value: _addCommentCubit),
        BlocProvider.value(value: _addAssigneeCubit),
        BlocProvider.value(value: _removeAssigneeCubit),
      ],
      child: Scaffold(
        backgroundColor: context.appBackgroundColor,
        appBar: CustomAppBar(
          title: LocaleKeys.task_details_title.tr(),
          actions: [
            BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
              builder: (context, state) {
                if (state is TaskDetailsLoaded) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => _showDeleteConfirmation(context, state.task),
                            borderRadius: AppRadius.circularMd,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: AppRadius.circularMd,
                                border: Border.all(
                                  color: AppColors.error.withValues(alpha: 0.2),
                                ),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.error,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          InkWell(
                            onTap: () async {
                              final result = await context.push(Routes.ownerTasksEdit, extra: state.task);
                              if (result == true && context.mounted) {
                                _cubit.fetchTaskDetails(widget.taskId, refresh: true);
                              }
                            },
                            borderRadius: AppRadius.circularMd,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: context.primaryColor.withValues(alpha: 0.1),
                                borderRadius: AppRadius.circularMd,
                                border: Border.all(
                                  color: context.primaryColor.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                color: context.primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
          builder: (context, state) {
            if (state is TaskDetailsLoading || state is TaskDetailsInitial) {
              return _buildShimmer();
            } else if (state is TaskDetailsError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => _cubit.fetchTaskDetails(widget.taskId),
              );
            } else if (state is TaskDetailsLoaded) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<UpdateTaskStatusCubit, UpdateTaskStatusState>(
                    listener: (context, updateState) {
                      if (updateState is UpdateTaskStatusSuccess) {
                        AppToast.showSuccess(context, LocaleKeys.task_updated_successfully.tr());
                        _cubit.fetchTaskDetails(widget.taskId, refresh: true);
                      } else if (updateState is UpdateTaskStatusError) {
                        AppToast.showError(context, updateState.message);
                      }
                    },
                  ),
                  BlocListener<UpdateTaskProgressCubit, UpdateTaskProgressState>(
                    listener: (context, progressState) {
                      if (progressState is UpdateTaskProgressSuccess) {
                        AppToast.showSuccess(context, LocaleKeys.task_progress_updated_successfully.tr());
                        _cubit.fetchTaskDetails(widget.taskId, refresh: true);
                      } else if (progressState is UpdateTaskProgressError) {
                        AppToast.showError(context, progressState.message);
                      }
                    },
                  ),
                  BlocListener<UpdateTaskPriorityCubit, UpdateTaskPriorityState>(
                    listener: (context, priorityState) {
                      if (priorityState is UpdateTaskPrioritySuccess) {
                        AppToast.showSuccess(context, LocaleKeys.task_priority_updated_successfully.tr());
                        _cubit.fetchTaskDetails(widget.taskId, refresh: true);
                      } else if (priorityState is UpdateTaskPriorityError) {
                        AppToast.showError(context, priorityState.message);
                      }
                    },
                  ),
                  BlocListener<UpdateTaskDatesCubit, UpdateTaskDatesState>(
                    listener: (context, datesState) {
                      if (datesState is UpdateTaskDatesSuccess) {
                        AppToast.showSuccess(context, LocaleKeys.task_dates_updated_successfully.tr());
                        _cubit.fetchTaskDetails(widget.taskId, refresh: true);
                        Navigator.pop(context);
                      } else if (datesState is UpdateTaskDatesError) {
                        AppToast.showError(context, datesState.message);
                      }
                    },
                  ),
                  BlocListener<AddTaskCommentCubit, AddTaskCommentState>(
                    listener: (context, commentState) {
                      if (commentState is AddTaskCommentSuccess) {
                        AppToast.showSuccess(context, LocaleKeys.comment_added_successfully.tr());
                        _cubit.fetchTaskDetails(widget.taskId, refresh: true);
                      } else if (commentState is AddTaskCommentError) {
                        AppToast.showError(context, commentState.message);
                      }
                    },
                  ),
                  BlocListener<AddTaskAssigneeCubit, AddTaskAssigneeState>(
                    listener: (context, assigneeState) {
                      if (assigneeState is AddTaskAssigneeSuccess) {
                        AppToast.showSuccess(context, LocaleKeys.assignee_added_successfully.tr());
                        _cubit.fetchTaskDetails(widget.taskId, refresh: true);
                        Navigator.pop(context); // Close bottom sheet
                      } else if (assigneeState is AddTaskAssigneeError) {
                        AppToast.showError(context, assigneeState.message);
                      }
                    },
                  ),
                  BlocListener<RemoveTaskAssigneeCubit, RemoveTaskAssigneeState>(
                    listener: (context, removeState) {
                      if (removeState is RemoveTaskAssigneeSuccess) {
                        AppToast.showSuccess(context, LocaleKeys.assignee_removed_successfully.tr());
                        _cubit.fetchTaskDetails(widget.taskId, refresh: true);
                        Navigator.pop(context); // Close dialog
                      } else if (removeState is RemoveTaskAssigneeError) {
                        AppToast.showError(context, removeState.message);
                      }
                    },
                  ),
                ],
                child: _buildContent(context, state.task),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, TaskEntity task) {
    showDialog(
      context: context,
      builder: (ctx) => BlocConsumer<DeleteTaskCubit, DeleteTaskState>(
        bloc: _deleteCubit,
        listener: (context, state) {
          if (state is DeleteTaskSuccess) {
            Navigator.pop(ctx);
            AppToast.showSuccess(context, LocaleKeys.task_deleted_successfully.tr());
            context.pop(true);
          } else if (state is DeleteTaskError) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is DeleteTaskLoading;
          return AlertDialog(
            backgroundColor: context.appSurfaceColor,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
            title: Text(
              LocaleKeys.delete_task.tr(),
              style: AppTextStyles.h3.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              LocaleKeys.delete_task_confirmation.tr(),
              style: AppTextStyles.bodyMedium.copyWith(color: context.appSecondaryTextColor),
            ),
            actionsPadding: const EdgeInsets.all(AppSpacing.md),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(ctx),
                child: Text(
                  LocaleKeys.cancel.tr(),
                  style: AppTextStyles.labelLarge.copyWith(color: context.appSecondaryTextColor),
                ),
              ),
              CustomButton(
                text: LocaleKeys.delete.tr(),
                onPressed: () => _deleteCubit.deleteTask(widget.taskId),
                isLoading: isLoading,
                width: 100,
                type: ButtonType.primary,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, TaskEntity task) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () async {
        await _cubit.fetchTaskDetails(widget.taskId, refresh: true);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMainCard(context, task),
            const SizedBox(height: AppSpacing.lg),
            if (task.dates != null) ...[
              TaskDatesCard(
                dates: task.dates!,
                onEditPressed: () => _showUpdateDatesBottomSheet(context, task.dates!),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            TaskLinkedEntityCard(task: task),
            if (task.linkedEntity != null) const SizedBox(height: AppSpacing.lg),
            if (task.description != null && task.description!.isNotEmpty) ...[
              _buildSectionHeader(context, LocaleKeys.details.tr(), Icons.description_outlined),
              const SizedBox(height: AppSpacing.sm),
              AppSurfaceCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  task.description!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.appSecondaryTextColor,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            if (task.notes != null && task.notes!.isNotEmpty) ...[
              _buildSectionHeader(context, LocaleKeys.notes.tr(), Icons.sticky_note_2_outlined),
              const SizedBox(height: AppSpacing.sm),
              AppSurfaceCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  task.notes!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.appSecondaryTextColor,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            TaskAssigneesSection(
              taskId: task.id,
              assignees: task.assignees ?? [],
            ),
            const SizedBox(height: AppSpacing.lg),
            TaskCommentsSection(
              taskId: task.id,
              comments: task.comments ?? [],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context, TaskEntity task) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.code != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: context.appSecondaryTextColor.withValues(alpha: 0.08),
                          borderRadius: AppRadius.circularSm,
                        ),
                        child: Text(
                          '#${task.code}',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: context.appSecondaryTextColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    Text(
                      task.title,
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w800,
                        color: context.appOnSurfaceColor,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              if (task.status != null) _buildStatusPill(context, task.status!),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          InkWell(
            onTap: () => _showProgressBottomSheet(context, task.progress),
            borderRadius: AppRadius.circularMd,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.04),
                borderRadius: AppRadius.circularMd,
                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.progress.tr(),
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${task.progress}%',
                            style: AppTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: AppRadius.circularSm,
                    child: LinearProgressIndicator(
                      value: task.progress / 100,
                      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                      color: Theme.of(context).primaryColor,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              if (task.priority != null)
                _buildInfoChip(
                  context,
                  icon: Icons.flag_rounded,
                  label: task.priority!.label,
                  color: ColorHelper.parseHexColor(task.priority!.color, AppColors.warning),
                  onTap: () => _showPriorityBottomSheet(context, task.priority!.value),
                  showEdit: true,
                ),
              if (task.category != null)
                _buildInfoChip(
                  context,
                  icon: Icons.category_rounded,
                  label: task.category!.label,
                  color: ColorHelper.parseHexColor(task.category!.color, AppColors.info),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(BuildContext context, TaskOptionEntity status) {
    final bgColor = ColorHelper.parseHexColor(status.backgroundColor, Theme.of(context).primaryColor.withValues(alpha: 0.1));
    final textColor = ColorHelper.parseHexColor(status.color, Theme.of(context).primaryColor);
    return BlocBuilder<UpdateTaskStatusCubit, UpdateTaskStatusState>(
      builder: (context, state) {
        final isLoading = state is UpdateTaskStatusLoading;
        return InkWell(
          onTap: isLoading ? null : () => _showStatusBottomSheet(context),
          borderRadius: AppRadius.circularLg,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: AppRadius.circularLg,
              border: Border.all(color: textColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2, color: textColor),
                  )
                else
                  Icon(Icons.edit_outlined, size: 14, color: textColor),
                const SizedBox(width: 6),
                Text(
                  '${LocaleKeys.status.tr()}: ${status.label}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: textColor),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStatusBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appSurfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) => TaskDetailsStatusBottomSheet(
        formDataCubit: _formDataCubit,
        updateStatusCubit: _updateStatusCubit,
        taskId: widget.taskId,
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
    bool showEdit = false,
  }) {
    Widget chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularSm,
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (showEdit) ...[
            const SizedBox(width: AppSpacing.xs),
            Icon(Icons.edit_outlined, size: 14, color: color),
          ],
        ],
      ),
    );

    if (onTap != null) {
      chip = InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circularSm,
        child: chip,
      );
    }
    return chip;
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w800,
            color: context.appOnSurfaceColor,
          ),
        ),
      ],
    );
  }

  void _showProgressBottomSheet(BuildContext context, int initialProgress) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appSurfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => TaskDetailsProgressBottomSheet(
        updateProgressCubit: _updateProgressCubit,
        taskId: widget.taskId,
        initialProgress: initialProgress,
      ),
    );
  }

  void _showPriorityBottomSheet(BuildContext context, String currentPriority) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.appSurfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => TaskDetailsPriorityBottomSheet(
        formDataCubit: _formDataCubit,
        updatePriorityCubit: _updatePriorityCubit,
        taskId: widget.taskId,
      ),
    );
  }

  void _showUpdateDatesBottomSheet(BuildContext context, TaskDatesEntity currentDates) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.appSurfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => TaskDetailsDatesBottomSheet(
        updateDatesCubit: _updateDatesCubit,
        taskId: widget.taskId,
        currentDates: currentDates,
      ),
    );
  }

  Widget _buildShimmer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppShimmer.box(height: 160, borderRadius: AppRadius.circularMd),
          const SizedBox(height: AppSpacing.md),
          AppShimmer.box(height: 140, borderRadius: AppRadius.circularMd),
          const SizedBox(height: AppSpacing.md),
          AppShimmer.box(height: 80, borderRadius: AppRadius.circularMd),
        ],
      ),
    );
  }
}








