import 'package:flutter/material.dart';
import '../../domain/entities/technician_performance_item_entity.dart';
import 'technician_performance_report_item_card.dart';

class TechnicianPerformanceReportList extends StatelessWidget {
  final List<TechnicianPerformanceItemEntity> items;

  const TechnicianPerformanceReportList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return TechnicianPerformanceReportItemCard(item: items[index]);
      },
    );
  }
}
