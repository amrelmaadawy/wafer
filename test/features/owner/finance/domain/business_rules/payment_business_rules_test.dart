import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/constants/payment_status.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/features/owner/finance/domain/business_rules/payment_business_rules.dart';

void main() {
  group('PaymentBusinessRules', () {
    test('canTransitionTo validates valid and invalid payment transitions', () {
      expect(
        PaymentBusinessRules.canTransitionTo(PaymentStatus.draft, PaymentStatus.pending),
        isTrue,
      );
      expect(
        PaymentBusinessRules.canTransitionTo(PaymentStatus.pending, PaymentStatus.approved),
        isTrue,
      );
      expect(
        PaymentBusinessRules.canTransitionTo(PaymentStatus.approved, PaymentStatus.paid),
        isTrue,
      );
      expect(
        PaymentBusinessRules.canTransitionTo(PaymentStatus.paid, PaymentStatus.reconciled),
        isTrue,
      );
      expect(
        PaymentBusinessRules.canTransitionTo(PaymentStatus.paid, PaymentStatus.reversed),
        isTrue,
      );
      expect(
        PaymentBusinessRules.canTransitionTo(PaymentStatus.paid, PaymentStatus.draft),
        isFalse,
      );
      expect(
        PaymentBusinessRules.canTransitionTo(PaymentStatus.reversed, PaymentStatus.paid),
        isFalse,
      );
    });

    test('validateTransition returns violation for invalid transitions and null for valid', () {
      final valid = PaymentBusinessRules.validateTransition(
        PaymentStatus.draft,
        PaymentStatus.pending,
      );
      expect(valid, isNull);

      final invalid = PaymentBusinessRules.validateTransition(
        PaymentStatus.reversed,
        PaymentStatus.draft,
      );
      expect(invalid, isNotNull);
      expect(invalid!.code, 'INVALID_PAYMENT_TRANSITION');
      expect(invalid.messageKey, LocaleKeys.brPaymentInvalidTransition);
    });

    test('isFieldEditable locks sensitive financial fields after finalized', () {
      expect(
        PaymentBusinessRules.isFieldEditable(PaymentStatus.draft, 'amount'),
        isTrue,
      );
      expect(
        PaymentBusinessRules.isFieldEditable(PaymentStatus.pending, 'payee'),
        isTrue,
      );
      expect(
        PaymentBusinessRules.isFieldEditable(PaymentStatus.paid, 'amount'),
        isFalse,
      );
      expect(
        PaymentBusinessRules.isFieldEditable(PaymentStatus.reconciled, 'paymentDate'),
        isFalse,
      );
    });
  });
}
