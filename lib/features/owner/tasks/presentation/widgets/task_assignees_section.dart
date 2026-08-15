import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../domain/entities/task_entity.dart';
import '../cubits/add_assignee/add_task_assignee_cubit.dart';
import '../cubits/add_assignee/add_task_assignee_state.dart';
import '../cubits/remove_assignee/remove_task_assignee_cubit.dart';
import '../cubits/remove_assignee/remove_task_assignee_state.dart';

class TaskAssigneesSection extends StatelessWidget {
  final int taskId;
  final List<TaskAssigneeEntity> assignees;

  const TaskAssigneesSection({
    super.key,
    required this.taskId,
    required this.assignees,
  });

  void _showAddAssigneeBottomSheet(BuildContext context) {
    final TextEditingController idController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<AddTaskAssigneeCubit>(),
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    LocaleKeys.add_assignee.tr(),
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.appOnSurfaceColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextField(
                    label: LocaleKeys.user_id.tr(),
                    hintText: LocaleKeys.enter_user_id.tr(),
                    controller: idController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  BlocBuilder<AddTaskAssigneeCubit, AddTaskAssigneeState>(
                    builder: (context, state) {
                      final isLoading = state is AddTaskAssigneeLoading;
                      return CustomButton(
                        text: LocaleKeys.save.tr(),
                        onPressed: () {
                          final idText = idController.text.trim();
                          if (idText.isEmpty) return;
                          final userId = int.tryParse(idText);
                          if (userId != null) {
                            context.read<AddTaskAssigneeCubit>().addAssignee(taskId, userId);
                          }
                        },
                        isLoading: isLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRemoveConfirmationDialog(BuildContext context, TaskAssigneeEntity assignee) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<RemoveTaskAssigneeCubit>(),
          child: AlertDialog(
            title: Text(
              LocaleKeys.remove_assignee.tr(),
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
            content: Text(
              LocaleKeys.remove_assignee_confirmation.tr(),
              style: AppTextStyles.bodyMedium,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  LocaleKeys.cancel.tr(),
                  style: TextStyle(color: context.appSecondaryTextColor),
                ),
              ),
              BlocBuilder<RemoveTaskAssigneeCubit, RemoveTaskAssigneeState>(
                builder: (context, state) {
                  final isLoading = state is RemoveTaskAssigneeLoading && state.assigneeId == assignee.id;
                  return CustomButton(
                    text: LocaleKeys.confirm.tr(),
                    width: 100,
                    isLoading: isLoading,
                    onPressed: () {
                      context.read<RemoveTaskAssigneeCubit>().removeAssignee(taskId, assignee.id);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.people_outline_rounded, color: Theme.of(context).primaryColor, size: 22),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  LocaleKeys.assignees.tr(),
                  style: AppTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.appOnSurfaceColor,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () => _showAddAssigneeBottomSheet(context),
              icon: Icon(Icons.add_circle_outline_rounded, color: Theme.of(context).primaryColor),
              tooltip: LocaleKeys.add_assignee.tr(),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (assignees.isEmpty)
          AppSurfaceCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.lg),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.people_outline_rounded,
                      size: 28,
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    LocaleKeys.no_assignees_yet.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: context.appSecondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: assignees.map((assignee) {
              return AppSurfaceCard(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      child: Icon(Icons.person_rounded, size: 14, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      assignee.name ?? assignee.id.toString(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.appOnSurfaceColor,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GestureDetector(
                      onTap: () => _showRemoveConfirmationDialog(context, assignee),
                      child: Icon(Icons.close_rounded, size: 16, color: context.appSecondaryTextColor),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
