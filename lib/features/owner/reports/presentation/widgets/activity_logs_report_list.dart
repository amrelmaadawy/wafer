import 'package:flutter/material.dart';
import '../../domain/entities/activity_logs_item_entity.dart';
import 'activity_logs_report_item_card.dart';

class ActivityLogsReportList extends StatelessWidget {
  final List<ActivityLogsItemEntity> items;

  const ActivityLogsReportList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = items[index];
        return ActivityLogsReportItemCard(item: item);
      }, childCount: items.length),
    );
  }
}
