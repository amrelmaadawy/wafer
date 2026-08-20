import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/contracts/data/models/contract_item_model.dart';

void main() {
  group('ContractItemModel', () {
    test('parses nested property, unit, and renter without UI fallbacks', () {
      final model = ContractItemModel.fromJson({
        'id': 8,
        'contract_number': 'C-8',
        'property': {'name': 'Tower'},
        'unit': {'name': 'A-4'},
        'renter': {'name': 'Renter One'},
        'financial': {'total_rent_value': '1250.5'},
        'status': 'active',
      });

      expect(model.id, '8');
      expect(model.propertyName, 'Tower');
      expect(model.unitName, 'A-4');
      expect(model.renterName, 'Renter One');
      expect(model.totalRentValue, 1250.5);
    });

    test('uses empty typed values for missing optional payload fields', () {
      final model = ContractItemModel.fromJson({'id': 1});

      expect(model.contractNumber, isEmpty);
      expect(model.propertyName, isEmpty);
      expect(model.renterName, isEmpty);
      expect(model.status, isEmpty);
    });
  });
}
