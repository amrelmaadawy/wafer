import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/finance/data/models/finance_account_model.dart';
import 'package:wafer/features/owner/finance/domain/entities/finance_account_type.dart';

void main() {
  group('FinanceAccountModel', () {
    test('should parse valid json correctly', () {
      final json = {
        'id': 1,
        'parent_id': null,
        'code': '101',
        'name_ar': 'نقدية',
        'name_en': 'Cash',
        'type': 'asset',
        'is_postable': 1,
        'level': 1,
        'is_active': true,
      };

      final result = FinanceAccountModel.fromJson(json);

      expect(result.id, 1);
      expect(result.code, '101');
      expect(result.type, FinanceAccountType.asset);
      expect(result.isPostable, true);
      expect(result.isActive, true);
    });

    test('should parse numbers passed as strings', () {
      final json = {
        'id': '2',
        'code': '201',
        'name_ar': 'دائنون',
        'name_en': 'Creditors',
        'type': 'liability',
        'is_postable': '0',
        'level': '2',
        'is_active': 'false',
      };

      final result = FinanceAccountModel.fromJson(json);

      expect(result.id, 2);
      expect(result.isPostable, false);
      expect(result.level, 2);
      expect(result.isActive, false);
    });

    test('should fallback to unknown type when type is not recognized', () {
      final json = {
        'id': 3,
        'code': '301',
        'name_ar': 'Test',
        'name_en': 'Test',
        'type': 'weird_type',
        'is_postable': 1,
        'level': 1,
        'is_active': 1,
      };

      final result = FinanceAccountModel.fromJson(json);
      expect(result.type, FinanceAccountType.unknown);
    });
  });
}
