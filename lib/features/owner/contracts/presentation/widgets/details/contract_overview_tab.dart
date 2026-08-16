import 'package:flutter/material.dart';
import '../../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../domain/entities/contract_details_entity.dart';
import 'contract_details_content.dart';

class ContractOverviewTab extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractOverviewTab({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 20, bottom: 40),
      child: AppResponsiveContent(
        child: ContractDetailsContent(contract: contract),
      ),
    );
  }
}
