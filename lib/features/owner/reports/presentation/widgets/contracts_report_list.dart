import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/contracts_report_item_entity.dart';
import 'contracts_report_item_card.dart';

class ContractsReportList extends StatelessWidget {
  final List<ContractsReportItemEntity> contracts;

  const ContractsReportList({super.key, required this.contracts});

  @override
  Widget build(BuildContext context) {
    if (contracts.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.description_rounded,
                size: 18, color: AppColors.textPrimaryLight),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.reports_contracts.tr(),
              style: const TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: contracts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            return ContractsReportItemCard(contract: contracts[index]);
          },
        ),
      ],
    );
  }
}
