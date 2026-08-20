import 'package:flutter/material.dart';
import '../../../domain/entities/contract_details_entity.dart';
import 'contract_details_financial_card.dart';
import 'contract_details_header_card.dart';
import 'contract_details_installments_action_card.dart';
import 'contract_details_property_card.dart';
import 'contract_details_renter_card.dart';
import 'contract_details_ejar_card.dart';
import 'contract_details_settings_card.dart';
import 'contract_details_handover_card.dart';

class ContractDetailsContent extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDetailsContent({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return _CardColumn(
            children: [
              ContractDetailsHeaderCard(contract: contract),
              ContractDetailsPropertyCard(contract: contract),
              ContractDetailsRenterCard(contract: contract),
              ContractDetailsEjarCard(contract: contract),
              ContractDetailsSettingsCard(contract: contract),
              ContractDetailsHandoverCard(contract: contract),
              ContractDetailsFinancialCard(contract: contract),
              _installmentsCard,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _CardColumn(
                children: [
                  ContractDetailsHeaderCard(contract: contract),
                  ContractDetailsPropertyCard(contract: contract),
                  ContractDetailsRenterCard(contract: contract),
                  ContractDetailsEjarCard(contract: contract),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _CardColumn(
                children: [
                  ContractDetailsSettingsCard(contract: contract),
                  ContractDetailsHandoverCard(contract: contract),
                  ContractDetailsFinancialCard(contract: contract),
                  _installmentsCard,
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget get _installmentsCard => ContractDetailsInstallmentsActionCard(
    contractId: contract.id,
    contractNumber: contract.contractNumber,
    installmentsCount: contract.paymentCount,
  );
}

class _CardColumn extends StatelessWidget {
  final List<Widget> children;

  const _CardColumn({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(height: 16),
          children[index],
        ],
      ],
    );
  }
}
