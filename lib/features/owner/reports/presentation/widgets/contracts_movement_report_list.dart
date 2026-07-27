import 'package:flutter/material.dart';
import '../../domain/entities/contracts_movement_item_entity.dart';
import 'contracts_movement_report_item_card.dart';

class ContractsMovementReportList extends StatelessWidget {
  final List<ContractsMovementItemEntity> items;

  const ContractsMovementReportList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return ContractsMovementReportItemCard(item: items[index]);
      },
    );
  }
}
