import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../domain/entities/maintenance_item_entity.dart';

class MaintenanceActionLogsSection extends StatelessWidget {
  final MaintenanceItemEntity item;

  const MaintenanceActionLogsSection({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.actionLogs == null || item.actionLogs!.isEmpty) {
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
              Icon(Icons.history, size: 20, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              const Text(
                'سجل الإجراءات', // Localize later
                style: TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...item.actionLogs!.asMap().entries.map((entry) {
            final isLast = entry.key == item.actionLogs!.length - 1;
            return _buildLogItem(context, entry.value, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildLogItem(BuildContext context, dynamic log, bool isLast) {
    // Determine icon and color based on action type
    IconData icon = Icons.info_outline;
    Color color = AppColors.primary;
    
    final action = log.action ?? '';
    if (action == 'created') {
      icon = Icons.add_circle_outline;
      color = AppColors.info;
    } else if (action == 'approved') {
      icon = Icons.check_circle_outline;
      color = AppColors.success;
    } else if (action == 'assigned') {
      icon = Icons.assignment_ind_outlined;
      color = AppColors.warning;
    } else if (action == 'executed') {
      icon = Icons.verified_outlined;
      color = AppColors.success;
    } else if (action == 'cancelled' || action == 'rejected') {
      icon = Icons.cancel_outlined;
      color = AppColors.error;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(icon, size: 16, color: color),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.borderLight,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (log.createdAt != null)
                    Text(
                      log.createdAt!,
                      style: const TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 4),
                  if (log.notes != null && log.notes!.isNotEmpty)
                    Text(
                      log.notes!,
                      style: const TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  if (log.newStatus != null && log.newStatus!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: AppRadius.circularSm,
                      ),
                      child: Text(
                        'حالة الطلب: ${log.newStatus}',
                        style: const TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
