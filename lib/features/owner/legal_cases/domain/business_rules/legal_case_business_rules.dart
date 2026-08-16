import '../../../../../core/constants/legal_case_status.dart';
import '../../../../../core/domain/business_rule_violation.dart';
import '../../../../../core/localization/locale_keys.dart';

class LegalCaseBusinessRules {
  LegalCaseBusinessRules._();

  static const Map<String, List<String>> allowedTransitions = {
    LegalCaseStatus.open: [
      LegalCaseStatus.inProgress,
      LegalCaseStatus.closed,
    ],
    LegalCaseStatus.inProgress: [
      LegalCaseStatus.hearing,
      LegalCaseStatus.resolved,
      LegalCaseStatus.closed,
    ],
    LegalCaseStatus.hearing: [
      LegalCaseStatus.resolved,
      LegalCaseStatus.inProgress,
      LegalCaseStatus.closed,
    ],
    LegalCaseStatus.resolved: [
      LegalCaseStatus.closed,
    ],
    LegalCaseStatus.closed: [],
  };

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
      code: 'INVALID_LEGAL_CASE_TRANSITION',
      messageKey: LocaleKeys.brLegalCaseInvalidTransition,
    );
  }

  static bool isFieldEditable(String? currentStatus, String fieldName) {
    if (currentStatus == null) return false;
    final current = currentStatus.toLowerCase().trim();
    return current != LegalCaseStatus.closed && current != LegalCaseStatus.resolved;
  }
}
