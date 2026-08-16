import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../domain/entities/task_entity.dart';

class TaskListItemFooter extends StatelessWidget {
  final TaskEntity task;
  final bool isOverdue;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskListItemFooter({
    super.key,
    required this.task,
    required this.isOverdue,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: context.appBorderColor.withValues(alpha: 0.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isOverdue && task.dates?.dueDate != null) ...[
                _buildDateChip(context, task.dates!.dueDate!, true),
                const Spacer(),
              ],
              _buildActionBtn(
                context,
                label: LocaleKeys.common_edit.tr(),
                icon: Icons.edit_outlined,
                color: context.primaryColor,
                onTap: onEdit,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildActionBtn(
                context,
                label: LocaleKeys.delete.tr(),
                icon: Icons.delete_outline_rounded,
                color: AppColors.error,
                onTap: onDelete,
              ),
            ],
          ),
        ),
      ],
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
}





