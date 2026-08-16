import '../../../../../core/constants/task_status.dart';
import '../../../../../core/domain/business_rule_violation.dart';
import '../../../../../core/localization/locale_keys.dart';

class TaskBusinessRules {
  TaskBusinessRules._();

  static const Map<String, List<String>> allowedTransitions = {
    TaskStatus.created: [
      TaskStatus.assigned,
      TaskStatus.inProgress,
      TaskStatus.cancelled,
    ],
    TaskStatus.assigned: [
      TaskStatus.inProgress,
      TaskStatus.cancelled,
    ],
    TaskStatus.inProgress: [
      TaskStatus.completed,
      TaskStatus.cancelled,
    ],
    TaskStatus.overdue: [
      TaskStatus.completed,
      TaskStatus.cancelled,
      TaskStatus.inProgress,
    ],
    TaskStatus.completed: [],
    TaskStatus.cancelled: [],
  };

  static const Map<String, List<String>> editableFields = {
    TaskStatus.created: [
      'title',
      'description',
      'dueDate',
      'priority',
      'category',
      'assignees',
      'notes',
    ],
    TaskStatus.assigned: [
      'title',
      'description',
      'dueDate',
      'priority',
      'category',
      'assignees',
      'notes',
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
      code: 'INVALID_TASK_TRANSITION',
      messageKey: LocaleKeys.brTaskInvalidTransition,
    );
  }

  static bool isFieldEditable(String? currentStatus, String fieldName) {
    if (currentStatus == null) return false;
    final current = currentStatus.toLowerCase().trim();
    final fields = editableFields[current];
    return fields != null && fields.contains(fieldName);
  }
}
