import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/properties/data/models/unit_full_details_model.dart';

void main() {
  group('UnitFullDetailsModel contracts', () {
    test('parses current tenant and contract history into typed entities', () {
      final model = UnitFullDetailsModel.fromJson({
        'id': 7,
        'unit_number': 'A-12',
        'unit_status': 'occupied',
        'current_contract': {
          'id': 21,
          'contract_number': 'C-21',
          'status': 'active',
          'start_date': '2026-01-01',
          'end_date': '2026-12-31',
          'tenant': {'name': 'Tenant One'},
        },
        'contracts_history': [
          {
            'id': 11,
            'number': 'C-11',
            'status': 'expired',
            'renter': {'name': 'Previous Renter'},
          },
        ],
      });

      expect(model.currentContract?.renterName, 'Tenant One');
      expect(model.currentContract?.statusLabel, 'active');
      expect(model.contractsHistory, hasLength(1));
      expect(model.contractsHistory.single.contractNumber, 'C-11');
      expect(model.contractsHistory.single.renterName, 'Previous Renter');
    });

    test('ignores malformed contract payloads safely', () {
      final model = UnitFullDetailsModel.fromJson({
        'id': 7,
        'unit_number': 'A-12',
        'unit_status': 'vacant',
        'current_contract': 'invalid',
        'contracts_history': ['invalid', null],
      });

      expect(model.currentContract, isNull);
      expect(model.contractsHistory, isEmpty);
    });
  });
}
