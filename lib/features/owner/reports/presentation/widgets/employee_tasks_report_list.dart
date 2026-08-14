import 'package:flutter/material.dart';
import '../../../../../core/theme/app_breakpoints.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/employee_tasks_item_entity.dart';
import 'employee_tasks_report_item_card.dart';

class EmployeeTasksReportList extends StatelessWidget {
  final List<EmployeeTasksItemEntity> items;
  const EmployeeTasksReportList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= AppBreakpoints.expanded
        ? 3
        : width >= AppBreakpoints.compact
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
        mainAxisExtent: 174,
      ),
      itemBuilder: (_, index) =>
          EmployeeTasksReportItemCard(item: items[index]),
    );
  }
}
