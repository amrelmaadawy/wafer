import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../domain/entities/employee_tasks_item_entity.dart';
import 'employee_tasks_report_item_card.dart';

class EmployeeTasksReportList extends StatelessWidget {
  final List<EmployeeTasksItemEntity> items;

  const EmployeeTasksReportList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_ind_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.employeeTasksNoData.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return EmployeeTasksReportItemCard(item: items[index]);
          },
          childCount: items.length,
        ),
      ),
    );
  }
}
