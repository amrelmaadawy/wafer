import 'package:flutter/material.dart';
import '../../cubit/installments/owner_contract_installments_state.dart';
import 'installment_card.dart';
import 'installments_empty_widget.dart';
import 'installments_filter_bar.dart';
import 'installments_summary_card.dart';

class InstallmentsContent extends StatelessWidget {
  final OwnerContractInstallmentsLoaded state;

  const InstallmentsContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth >= 900
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;
        return Column(
          children: [
            InstallmentsSummaryCard(summary: state.summary),
            const SizedBox(height: 16),
            InstallmentsFilterBar(activeFilter: state.activeFilter),
            const SizedBox(height: 16),
            if (state.filteredInstallments.isEmpty)
              const InstallmentsEmptyWidget()
            else
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: state.filteredInstallments
                    .map(
                      (installment) => SizedBox(
                        width: cardWidth,
                        child: InstallmentCard(installment: installment),
                      ),
                    )
                    .toList(growable: false),
              ),
          ],
        );
      },
    );
  }
}
