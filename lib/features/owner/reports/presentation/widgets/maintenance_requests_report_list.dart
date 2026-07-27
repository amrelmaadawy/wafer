import 'package:flutter/material.dart';
import '../../domain/entities/maintenance_requests_item_entity.dart';
import 'maintenance_requests_report_item_card.dart';

class MaintenanceRequestsReportList extends StatelessWidget {
  final List<MaintenanceRequestsItemEntity> items;

  const MaintenanceRequestsReportList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return MaintenanceRequestsReportItemCard(item: items[index]);
      },
    );
  }
}
