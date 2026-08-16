import '../../../../../core/constants/contract_status.dart';
import '../../../../../core/domain/business_rule_violation.dart';
import '../../../../../core/localization/locale_keys.dart';

class ContractBusinessRules {
  ContractBusinessRules._();

  static const Map<String, List<String>> allowedTransitions = {
    ContractStatus.draft: [
      ContractStatus.active,
      ContractStatus.pending,
      ContractStatus.terminated,
    ],
    ContractStatus.pending: [
      ContractStatus.active,
      ContractStatus.draft,
      ContractStatus.terminated,
    ],
    ContractStatus.active: [
      ContractStatus.expiring,
      ContractStatus.terminated,
    ],
    ContractStatus.expiring: [
      'renewed',
      ContractStatus.expired,
      ContractStatus.terminated,
    ],
    ContractStatus.expired: [
      'renewed',
    ],
    ContractStatus.terminated: [],
    'renewed': [],
  };

  static const List<String> lockedFieldsWhenActive = [
    'totalRentValue',
    'startDate',
    'endDate',
    'paymentCycle',
    'securityDeposit',
    'propertyId',
    'unitId',
    'renterId',
  ];

  static bool canTransitionTo(String? currentStatus, String targetStatus) {
    if (currentStatus == null) return false;
    final current = currentStatus.toLowerCase().trim();
    final target = targetStatus.toLowerCase().trim();
    final allowed = allowedTransitions[current];
    return allowed != null && allowed.contains(target);
  }

  static bool isFieldEditable(String? currentStatus, String fieldName) {
    if (currentStatus == null) return false;
    final current = currentStatus.toLowerCase().trim();
    if (current == ContractStatus.draft || current == ContractStatus.pending) {
      return true;
    }
    return !lockedFieldsWhenActive.contains(fieldName);
  }

  static BusinessRuleViolation? validateFieldEdit(
    String? currentStatus,
    String fieldName,
  ) {
    if (isFieldEditable(currentStatus, fieldName)) {
      return null;
    }
    return const BusinessRuleViolation(
      code: 'CONTRACT_FIELD_LOCKED',
      messageKey: LocaleKeys.brContractFieldLocked,
    );
  }
}
