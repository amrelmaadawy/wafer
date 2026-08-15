import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/routing/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../cubit/list/tasks_list_cubit.dart';
import '../cubit/delete/delete_task_cubit.dart';
import '../cubit/delete/delete_task_state.dart';

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
        ? _parseColor(task.priority!.color, AppColors.primary)
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
                // ── Header strip ──────────────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.06),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
                  child: Row(
                    children: [
                      // Code badge
                      if (task.code != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: priorityColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            task.code!,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: priorityColor,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      const Spacer(),
                      // Status pill
                      if (task.status != null) _buildStatusPill(task.status!),
                    ],
                  ),
                ),

                // ── Body ──────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row with priority accent
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Priority accent bar
                          Container(
                            width: 3,
                            height: 44,
                            margin: const EdgeInsetsDirectional.only(end: 10),
                            decoration: BoxDecoration(
                              color: priorityColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: context.appOnSurfaceColor,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (task.description != null && task.description!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    task.description!,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: context.appSecondaryTextColor,
                                      height: 1.4,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Assignees
                          if (task.assignees != null && task.assignees!.isNotEmpty) ...[
                            const SizedBox(width: AppSpacing.sm),
                            _buildAssignees(context),
                          ],
                        ],
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Progress bar (if progress > 0)
                      if (task.progress > 0) ...[
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: task.progress / 100,
                                  minHeight: 6,
                                  backgroundColor: context.appBorderColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(priorityColor),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${task.progress}%',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: priorityColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // Chips row: category, priority, dates
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (task.priority != null)
                            _buildChip(
                              task.priority!.label,
                              _parseColor(task.priority!.color, AppColors.warning),
                            ),
                          if (task.category != null)
                            _buildChip(
                              task.category!.label,
                              _parseColor(task.category!.color, AppColors.info),
                            ),
                          if (isOverdue)
                            _buildChip(
                              '⚠ متأخرة',
                              AppColors.error,
                              filled: true,
                            ),
                          if (!isOverdue && task.dates?.dueDate != null)
                            _buildDateChip(context, task.dates!.dueDate!, false),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      // Linked entity / property info row
                      if (task.linkedEntity != null || task.property != null || task.deed != null)
                        _buildMetaRow(context),
                    ],
                  ),
                ),

                // ── Footer divider + actions ──────────────────────────────
                Divider(height: 1, color: context.appBorderColor.withValues(alpha: 0.5)),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Overdue date chip (if overdue, show in footer too)
                      if (isOverdue && task.dates?.dueDate != null) ...[
                        _buildDateChip(context, task.dates!.dueDate!, true),
                        const Spacer(),
                      ],
                      _buildActionBtn(
                        context,
                        label: LocaleKeys.common_edit.tr(),
                        icon: Icons.edit_outlined,
                        color: context.primaryColor,
                        onTap: () => _onEdit(context),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _buildActionBtn(
                        context,
                        label: LocaleKeys.delete.tr(),
                        icon: Icons.delete_outline_rounded,
                        color: AppColors.error,
                        onTap: () => _showDeleteDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaRow(BuildContext context) {
    final items = <Widget>[];

    if (task.linkedEntity?.name != null) {
      items.add(_buildMetaChip(
        context,
        icon: Icons.link_rounded,
        label: task.linkedEntity!.name!,
        color: context.appSecondaryTextColor,
      ));
    }

    if (task.property != null) {
      final prop = task.property!;
      final label = prop.name?.isNotEmpty == true ? prop.name! : prop.code ?? '';
      if (label.isNotEmpty) {
        items.add(_buildMetaChip(
          context,
          icon: Icons.home_work_outlined,
          label: label,
          color: context.appSecondaryTextColor,
        ));
      }
    }

    if (task.branch != null && task.branch!.name != null) {
      items.add(_buildMetaChip(
        context,
        icon: Icons.business_outlined,
        label: task.branch!.name!,
        color: context.appSecondaryTextColor,
      ));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: 6, runSpacing: 6, children: items);
  }

  Widget _buildMetaChip(BuildContext context, {required IconData icon, required String label, required Color color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color.withValues(alpha: 0.7)),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circularSm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: AppRadius.circularSm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(TaskOptionEntity status) {
    final bgColor = _parseColor(status.backgroundColor, AppColors.primary.withValues(alpha: 0.1));
    final textColor = _parseColor(status.color, AppColors.primary);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        status.label,
        style: AppTextStyles.labelSmall.copyWith(color: textColor, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildChip(String label, Color color, {bool filled = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: filled ? Colors.white : color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildDateChip(BuildContext context, String date, bool isOverdue) {
    final color = isOverdue ? AppColors.error : context.appSecondaryTextColor;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isOverdue ? Icons.warning_amber_rounded : Icons.calendar_today_rounded,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          date,
          style: AppTextStyles.labelSmall.copyWith(
            color: color,
            fontWeight: isOverdue ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAssignees(BuildContext context) {
    final count = task.assignees!.length;
    final displayCount = count > 3 ? 3 : count;
    return SizedBox(
      width: (displayCount * 18.0) + 10.0,
      height: 30,
      child: Stack(
        children: List.generate(displayCount, (index) {
          return Positioned(
            right: index * 18.0,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.appSurfaceColor, width: 2),
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
              child: task.assignees![index].avatar != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(task.assignees![index].avatar!, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.person, size: 14, color: AppColors.primary),
            ),
          );
        }),
      ),
    );
  }

  Color _parseColor(String? hexString, Color fallback) {
    if (hexString == null || hexString.isEmpty) return fallback;
    try {
      final hex = hexString.replaceAll('#', '');
      if (hex.length == 6) return Color(int.parse('0xFF$hex'));
      if (hex.length == 8) return Color(int.parse('0x$hex'));
      return fallback;
    } catch (_) {
      return fallback;
    }
  }
}
