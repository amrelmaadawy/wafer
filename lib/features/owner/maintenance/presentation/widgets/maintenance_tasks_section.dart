import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../domain/entities/maintenance_item_entity.dart';

class MaintenanceTasksSection extends StatelessWidget {
  final MaintenanceItemEntity item;

  const MaintenanceTasksSection({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.tasks == null || item.tasks!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              const Text(
                'المهام الفرعية', // Localize later
                style: TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...item.tasks!.map((task) => _buildTaskRow(context, task)),
        ],
      ),
    );
  }

  Widget _buildTaskRow(BuildContext context, dynamic task) {
    final title = task.title ?? 'مهمة غير معروفة';
    final status = task.status ?? 'waiting'; // waiting, completed
    final isCompleted = status == 'completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.circularLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted
                ? AppColors.success
                : AppColors.textSecondaryLight,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isCompleted
                        ? AppColors.textSecondaryLight
                        : AppColors.textPrimaryLight,
                    fontSize: 14,
                    fontWeight: isCompleted ? FontWeight.w500 : FontWeight.w700,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (task.dueDate != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.dueDate!,
                        style: const TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
