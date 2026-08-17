import 'package:flutter/material.dart';
import '../../../../../core/activity/entities/activity_log_entity.dart';
import '../../../../../core/activity/widgets/activity_timeline_widget.dart';
import '../../domain/entities/maintenance_complex_sub_entities.dart';
import '../../domain/entities/maintenance_item_entity.dart';

class MaintenanceActionLogsSection extends StatelessWidget {
  final MaintenanceItemEntity item;

  const MaintenanceActionLogsSection({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final logs = item.actionLogs;
    if (logs == null || logs.isEmpty) {
      return const SizedBox.shrink();
    }

    final activities = logs.map(_mapLogToActivity).toList();

    return ActivityTimelineWidget(
      activities: activities,
      padding: EdgeInsets.zero,
      showHeader: true,
    );
  }

  ActivityLogEntity _mapLogToActivity(MaintenanceActionLogEntity log) {
    return ActivityLogEntity.inferred(
      id: log.id?.toString(),
      action: log.action,
      notes: log.notes,
      oldStatus: log.oldStatus,
      newStatus: log.newStatus,
      performedByName: log.performedBy?.toString(),
      createdAt: log.createdAt,
    );
  }
}
