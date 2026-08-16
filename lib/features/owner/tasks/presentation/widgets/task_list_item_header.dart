import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/helpers/color_helper.dart';
import '../../domain/entities/task_entity.dart';

class TaskListItemHeader extends StatelessWidget {
  final TaskEntity task;
  final Color priorityColor;

  const TaskListItemHeader({
    super.key,
    required this.task,
    required this.priorityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          if (task.status != null) _buildStatusPill(task.status!, context),
        ],
      ),
    );
  }

  Widget _buildStatusPill(TaskOptionEntity status, BuildContext context) {
    final bgColor = ColorHelper.parseHexColor(status.backgroundColor, AppColors.primary.withValues(alpha: 0.1));
    final textColor = ColorHelper.parseHexColor(status.color, AppColors.primary);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        status.label,
        style: AppTextStyles.labelSmall.copyWith(color: textColor, fontWeight: FontWeight.w700),
      ),
    );
  }
}


