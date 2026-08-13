import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/contracts/data/models/contract_details_model.dart';

void main() {
  test('parses wrapped contract details and financial values', () {
    final model = ContractDetailsModel.fromJson({
      'data': {
        'contract': {
          'id': 3,
          'contract_number': 'C-3',
          'property': {'id': 4, 'name': 'Property'},
          'unit': {'id': 5, 'name': 'Unit'},
          'tenant': {'id': 6, 'name': 'Tenant', 'phone': '0500'},
          'financial': {
            'total_rent_value': '24000',
            'payment_count': 12,
            'security_deposit': 2000,
          },
          'is_ejar_linked': 1,
        },
      },
    });

    expect(model.id, '3');
    expect(model.propertyId, '4');
    expect(model.unitName, 'Unit');
    expect(model.renterName, 'Tenant');
    expect(model.totalRentValue, 24000);
    expect(model.paymentCount, 12);
    expect(model.isEjarLinked, isTrue);
  });
}
