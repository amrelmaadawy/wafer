import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/constants/payment_status.dart';
import 'package:wafer/features/owner/finance/domain/entities/payment_entity.dart';
import 'package:wafer/features/owner/finance/domain/entities/payment_status_extension.dart';
import 'package:wafer/features/owner/finance/domain/entities/receipt_entity.dart';

void main() {
  group('PaymentStatusExtension', () {
    const payee = PaymentPayeeEntity(id: 1, name: 'Vendor', userType: 'vendor');
    const method = ReceiptTypeEntity(value: '1', label: 'Cash');
    const debitType = ReceiptTypeEntity(value: '2', label: 'Bank');

    PaymentEntity createPayment(String status) => PaymentEntity(
          id: 1,
          paymentNumber: 'PAY-001',
          paymentDate: '2026-01-01',
          amount: 500,
          paymentMethod: method,
          debitAccountType: debitType,
          status: status,
          payee: payee,
        );

    test('draft and pending payments allow edit, delete, and cancel', () {
      final draft = createPayment(PaymentStatus.draft);
      expect(draft.isDraft, isTrue);
      expect(draft.canEdit, isTrue);
      expect(draft.canDelete, isTrue);
      expect(draft.canCancel, isTrue);
      expect(draft.isFinalized, isFalse);

      final pending = createPayment(PaymentStatus.pending);
      expect(pending.isPending, isTrue);
      expect(pending.canEdit, isTrue);
      expect(pending.canDelete, isTrue);
      expect(pending.canCancel, isTrue);
    });

    test('paid payment is finalized, cannot edit/delete, but can reverse', () {
      final paid = createPayment(PaymentStatus.paid);
      expect(paid.isPaid, isTrue);
      expect(paid.isFinalized, isTrue);
      expect(paid.canEdit, isFalse);
      expect(paid.canDelete, isFalse);
      expect(paid.canReverse, isTrue);
    });

    test('reconciled and reversed payments are finalized', () {
      final reconciled = createPayment(PaymentStatus.reconciled);
      expect(reconciled.isReconciled, isTrue);
      expect(reconciled.isFinalized, isTrue);
      expect(reconciled.canEdit, isFalse);
      expect(reconciled.canDelete, isFalse);

      final reversed = createPayment(PaymentStatus.reversed);
      expect(reversed.isReversed, isTrue);
      expect(reversed.isFinalized, isTrue);
    });
  });
}
