import 'package:flutter/material.dart';
import '../../domain/entities/defaulters_report_item_entity.dart';
import 'defaulters_report_item_card.dart';

class DefaultersReportList extends StatelessWidget {
  final List<DefaultersReportItemEntity> items;

  const DefaultersReportList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return DefaultersReportItemCard(item: items[index]);
      },
    );
  }
}
