import '../../../../../core/constants/maintenance_status.dart';
import '../../../../../core/domain/business_rule_violation.dart';
import '../../../../../core/localization/locale_keys.dart';

class MaintenanceBusinessRules {
  MaintenanceBusinessRules._();

  static const Map<String, List<String>> allowedTransitions = {
    MaintenanceStatus.new_: [
      MaintenanceStatus.approved,
      MaintenanceStatus.rejected,
      MaintenanceStatus.cancelled,
    ],
    MaintenanceStatus.pendingSupervisor: [
      MaintenanceStatus.approved,
      MaintenanceStatus.rejected,
      MaintenanceStatus.cancelled,
    ],
    MaintenanceStatus.draft: [
      MaintenanceStatus.approved,
      MaintenanceStatus.rejected,
      MaintenanceStatus.cancelled,
    ],
    MaintenanceStatus.approved: [
      MaintenanceStatus.assigned,
      MaintenanceStatus.cancelled,
    ],
    MaintenanceStatus.assigned: [
      MaintenanceStatus.inProgress,
      MaintenanceStatus.cancelled,
    ],
    MaintenanceStatus.inProgress: [
      MaintenanceStatus.executed,
      MaintenanceStatus.cancelled,
    ],
    MaintenanceStatus.executed: [
      MaintenanceStatus.closed,
      MaintenanceStatus.cancelled,
    ],
    MaintenanceStatus.closed: [
      'forwarded',
    ],
    MaintenanceStatus.rejected: [],
    MaintenanceStatus.cancelled: [],
    'forwarded': [],
  };

  static const Map<String, List<String>> editableFields = {
    MaintenanceStatus.new_: [
      'title',
      'description',
      'types',
      'isPrivate',
      'costBearer',
      'propertyId',
      'unitId',
      'images',
    ],
    MaintenanceStatus.pendingSupervisor: [
      'title',
      'description',
      'types',
      'isPrivate',
      'costBearer',
      'propertyId',
      'unitId',
      'images',
    ],
    MaintenanceStatus.draft: [
      'title',
      'description',
      'types',
      'isPrivate',
      'costBearer',
      'propertyId',
      'unitId',
      'images',
    ],
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
      code: 'INVALID_MAINTENANCE_TRANSITION',
      messageKey: LocaleKeys.brMaintenanceInvalidTransition,
    );
  }

  static bool isFieldEditable(String? currentStatus, String fieldName) {
    if (currentStatus == null) return false;
    final current = currentStatus.toLowerCase().trim();
    final fields = editableFields[current];
    return fields != null && fields.contains(fieldName);
  }
}
