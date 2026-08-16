import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/helpers/color_helper.dart';
import '../../domain/entities/task_entity.dart';

class TaskListItemBody extends StatelessWidget {
  final TaskEntity task;
  final Color priorityColor;
  final bool isOverdue;

  const TaskListItemBody({
    super.key,
    required this.task,
    required this.priorityColor,
    required this.isOverdue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              if (task.assignees != null && task.assignees!.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.sm),
                _buildAssignees(context),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
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
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (task.priority != null)
                _buildChip(
                  task.priority!.label,
                  ColorHelper.parseHexColor(task.priority!.color, AppColors.warning),
                ),
              if (task.category != null)
                _buildChip(
                  task.category!.label,
                  ColorHelper.parseHexColor(task.category!.color, AppColors.info),
                ),
              if (isOverdue)
                _buildChip(
                  LocaleKeys.dashboardOverdue.tr(),
                  AppColors.error,
                  filled: true,
                  icon: Icons.warning_rounded,
                ),
              if (!isOverdue && task.dates?.dueDate != null)
                _buildDateChip(context, task.dates!.dueDate!, false),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (task.linkedEntity != null || task.property != null || task.deed != null)
            _buildMetaRow(context),
        ],
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

  Widget _buildChip(String label, Color color, {bool filled = false, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: filled ? Colors.white : color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: filled ? Colors.white : color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
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
}

