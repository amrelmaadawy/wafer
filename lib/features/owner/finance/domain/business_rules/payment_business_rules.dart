import '../../../../../core/constants/payment_status.dart';
import '../../../../../core/domain/business_rule_violation.dart';
import '../../../../../core/localization/locale_keys.dart';

class PaymentBusinessRules {
  PaymentBusinessRules._();

  static const Map<String, List<String>> allowedTransitions = {
    PaymentStatus.draft: [
      PaymentStatus.pending,
      'cancelled',
    ],
    PaymentStatus.pending: [
      PaymentStatus.approved,
      'cancelled',
    ],
    PaymentStatus.approved: [
      PaymentStatus.paid,
      'cancelled',
    ],
    PaymentStatus.paid: [
      PaymentStatus.reconciled,
      PaymentStatus.reversed,
    ],
    PaymentStatus.reconciled: [],
    PaymentStatus.reversed: [],
    'cancelled': [],
  };

  static const List<String> lockedWhenFinalized = [
    'amount',
    'paymentDate',
    'paymentMethod',
    'debitAccount',
    'creditAccount',
    'payee',
    'propertyId',
    'unitId',
    'contractId',
  ];

  static bool canTransitionTo(String? currentStatus, String targetStatus) {
    if (currentStatus == null) return false;
    final current = currentStatus.toLowerCase().trim();
    final target = targetStatus.toLowerCase().trim();
    final allowed = allowedTransitions[current];
    return allowed != null && allowed.contains(target);
  }

  static BusinessRuleViolation? validateTransition(
    String? currentStatus,
    String targetStatus,
  ) {
    if (canTransitionTo(currentStatus, targetStatus)) {
      return null;
    }
    return const BusinessRuleViolation(
      code: 'INVALID_PAYMENT_TRANSITION',
      messageKey: LocaleKeys.brPaymentInvalidTransition,
    );
  }

  static bool isFieldEditable(String? currentStatus, String fieldName) {
    if (currentStatus == null) return false;
    final current = currentStatus.toLowerCase().trim();
    final isFinalized = [
      PaymentStatus.paid,
      PaymentStatus.reconciled,
      PaymentStatus.reversed,
      'cancelled',
    ].contains(current);

    if (isFinalized) {
      return !lockedWhenFinalized.contains(fieldName);
    }
    return true;
  }

  static BusinessRuleViolation? validateFieldEdit(
    String? currentStatus,
    String fieldName,
  ) {
    if (isFieldEditable(currentStatus, fieldName)) {
      return null;
    }
    return const BusinessRuleViolation(
      code: 'PAYMENT_FIELD_LOCKED',
      messageKey: LocaleKeys.brPaymentFieldLocked,
    );
  }
}
