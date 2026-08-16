import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/constants/contract_status.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/features/owner/contracts/domain/business_rules/contract_business_rules.dart';

void main() {
  group('ContractBusinessRules', () {
    test('canTransitionTo validates valid transitions', () {
      expect(
        ContractBusinessRules.canTransitionTo(ContractStatus.draft, ContractStatus.active),
        isTrue,
      );
      expect(
        ContractBusinessRules.canTransitionTo(ContractStatus.active, ContractStatus.expiring),
        isTrue,
      );
      expect(
        ContractBusinessRules.canTransitionTo(ContractStatus.active, ContractStatus.draft),
        isFalse,
      );
      expect(
        ContractBusinessRules.canTransitionTo(ContractStatus.terminated, ContractStatus.active),
        isFalse,
      );
    });

    test('isFieldEditable locks financial and unit fields when active', () {
      expect(
        ContractBusinessRules.isFieldEditable(ContractStatus.draft, 'totalRentValue'),
        isTrue,
      );
      expect(
        ContractBusinessRules.isFieldEditable(ContractStatus.pending, 'startDate'),
        isTrue,
      );
      expect(
        ContractBusinessRules.isFieldEditable(ContractStatus.active, 'totalRentValue'),
        isFalse,
      );
      expect(
        ContractBusinessRules.isFieldEditable(ContractStatus.active, 'unitId'),
        isFalse,
      );
    });

    test('validateFieldEdit returns violation when editing locked field on active contract', () {
      final invalid = ContractBusinessRules.validateFieldEdit(
        ContractStatus.active,
        'totalRentValue',
      );
      expect(invalid, isNotNull);
      expect(invalid!.code, 'CONTRACT_FIELD_LOCKED');
      expect(invalid.messageKey, LocaleKeys.brContractFieldLocked);

      final valid = ContractBusinessRules.validateFieldEdit(
        ContractStatus.draft,
        'totalRentValue',
      );
      expect(valid, isNull);
    });
  });
}
