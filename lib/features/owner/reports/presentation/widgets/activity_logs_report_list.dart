import 'package:flutter/material.dart';
import '../../../../../core/theme/app_breakpoints.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/activity_logs_item_entity.dart';
import 'activity_logs_report_item_card.dart';

class ActivityLogsReportList extends StatelessWidget {
  const ActivityLogsReportList({super.key, required this.items});

  final List<ActivityLogsItemEntity> items;

  @override
  Widget build(BuildContext context) {
    final columns = context.isExpanded
        ? 3
        : context.isMedium
        ? 2
        : 1;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        mainAxisExtent: 216,
      ),
      itemBuilder: (_, index) => ActivityLogsReportItemCard(item: items[index]),
    );
  }
}
