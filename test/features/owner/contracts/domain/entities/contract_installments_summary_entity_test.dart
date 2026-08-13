import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/contracts/domain/entities/contract_installment_entity.dart';
import 'package:wafer/features/owner/contracts/domain/entities/contract_installments_summary_entity.dart';

void main() {
  test('calculates installment totals and progress in the domain', () {
    const installments = [
      ContractInstallmentEntity(
        id: 1,
        installmentNumber: 1,
        dueDate: '',
        amount: 100,
        paidAmount: 100,
        remaining: 0,
        status: 'paid',
        statusLabel: '',
      ),
      ContractInstallmentEntity(
        id: 2,
        installmentNumber: 2,
        dueDate: '',
        amount: 100,
        paidAmount: 25,
        remaining: 75,
        status: 'partially_paid',
        statusLabel: '',
      ),
    ];

    final summary = ContractInstallmentsSummaryEntity.fromInstallments(
      installments,
    );

    expect(summary.totalAmount, 200);
    expect(summary.paidAmount, 125);
    expect(summary.remainingAmount, 75);
    expect(summary.paidCount, 1);
    expect(summary.paidProgress, 0.625);
  });
}
