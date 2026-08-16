import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/constants/legal_case_status.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/features/owner/legal_cases/domain/business_rules/legal_case_business_rules.dart';

void main() {
  group('LegalCaseBusinessRules', () {
    test('canTransitionTo validates valid transitions', () {
      expect(
        LegalCaseBusinessRules.canTransitionTo(LegalCaseStatus.open, LegalCaseStatus.inProgress),
        isTrue,
      );
      expect(
        LegalCaseBusinessRules.canTransitionTo(LegalCaseStatus.inProgress, LegalCaseStatus.hearing),
        isTrue,
      );
      expect(
        LegalCaseBusinessRules.canTransitionTo(LegalCaseStatus.hearing, LegalCaseStatus.resolved),
        isTrue,
      );
      expect(
        LegalCaseBusinessRules.canTransitionTo(LegalCaseStatus.resolved, LegalCaseStatus.closed),
        isTrue,
      );
      expect(
        LegalCaseBusinessRules.canTransitionTo(LegalCaseStatus.closed, LegalCaseStatus.open),
        isFalse,
      );
    });

    test('validateTransition returns violation for invalid transitions and null for valid', () {
      final valid = LegalCaseBusinessRules.validateTransition(
        LegalCaseStatus.open,
        LegalCaseStatus.inProgress,
      );
      expect(valid, isNull);

      final invalid = LegalCaseBusinessRules.validateTransition(
        LegalCaseStatus.closed,
        LegalCaseStatus.open,
      );
      expect(invalid, isNotNull);
      expect(invalid!.code, 'INVALID_LEGAL_CASE_TRANSITION');
      expect(invalid.messageKey, LocaleKeys.brLegalCaseInvalidTransition);
    });

    test('isFieldEditable returns false only when resolved or closed', () {
      expect(
        LegalCaseBusinessRules.isFieldEditable(LegalCaseStatus.open, 'title'),
        isTrue,
      );
      expect(
        LegalCaseBusinessRules.isFieldEditable(LegalCaseStatus.inProgress, 'courtName'),
        isTrue,
      );
      expect(
        LegalCaseBusinessRules.isFieldEditable(LegalCaseStatus.closed, 'title'),
        isFalse,
      );
      expect(
        LegalCaseBusinessRules.isFieldEditable(LegalCaseStatus.resolved, 'courtName'),
        isFalse,
      );
    });
  });
}
