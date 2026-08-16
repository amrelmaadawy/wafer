import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/finance/data/models/unified_transaction_model.dart';
import 'package:wafer/features/owner/finance/domain/entities/unified_transaction_entity.dart';

void main() {
  group('UnifiedTransactionModel', () {
    test('fromJson parses receipt transaction correctly', () {
      final json = {
        'id': 101,
        'receipt_number': 'REC-101',
        'type': 'receipt',
        'receipt_date': '2026-08-16',
        'amount': 20000,
        'status': 'paid',
        'owner': {'name': 'Ahmed Ali'},
      };

      final model = UnifiedTransactionModel.fromJson(json);

      expect(model.id, 101);
      expect(model.referenceNumber, 'REC-101');
      expect(model.type, UnifiedTransactionType.receipt);
      expect(model.isPositive, isTrue);
      expect(model.amount, 20000);
      expect(model.partyName, 'Ahmed Ali');
    });

    test('fromJson parses payment transaction correctly', () {
      final json = {
        'id': 202,
        'payment_number': 'PAY-202',
        'type': 'payment',
        'payment_date': '2026-08-15',
        'amount': 5000,
        'status': 'paid',
        'payee': {'name': 'Al-Amal Maintenance'},
      };

      final model = UnifiedTransactionModel.fromJson(json);

      expect(model.id, 202);
      expect(model.referenceNumber, 'PAY-202');
      expect(model.type, UnifiedTransactionType.payment);
      expect(model.isPositive, isFalse);
      expect(model.amount, 5000);
      expect(model.partyName, 'Al-Amal Maintenance');
    });
  });
}
