import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/constants/task_status.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/features/owner/tasks/domain/business_rules/task_business_rules.dart';

void main() {
  group('TaskBusinessRules', () {
    test('canTransitionTo validates valid and invalid status transitions', () {
      expect(
        TaskBusinessRules.canTransitionTo(TaskStatus.created, TaskStatus.assigned),
        isTrue,
      );
      expect(
        TaskBusinessRules.canTransitionTo(TaskStatus.assigned, TaskStatus.inProgress),
        isTrue,
      );
      expect(
        TaskBusinessRules.canTransitionTo(TaskStatus.inProgress, TaskStatus.completed),
        isTrue,
      );
      expect(
        TaskBusinessRules.canTransitionTo(TaskStatus.completed, TaskStatus.inProgress),
        isFalse,
      );
      expect(
        TaskBusinessRules.canTransitionTo(TaskStatus.cancelled, TaskStatus.completed),
        isFalse,
      );
    });

    test('validateTransition returns violation for invalid transitions and null for valid', () {
      final valid = TaskBusinessRules.validateTransition(
        TaskStatus.inProgress,
        TaskStatus.completed,
      );
      expect(valid, isNull);

      final invalid = TaskBusinessRules.validateTransition(
        TaskStatus.completed,
        TaskStatus.inProgress,
      );
      expect(invalid, isNotNull);
      expect(invalid!.code, 'INVALID_TASK_TRANSITION');
      expect(invalid.messageKey, LocaleKeys.brTaskInvalidTransition);
    });

    test('isFieldEditable returns true only for created and assigned', () {
      expect(
        TaskBusinessRules.isFieldEditable(TaskStatus.created, 'title'),
        isTrue,
      );
      expect(
        TaskBusinessRules.isFieldEditable(TaskStatus.assigned, 'priority'),
        isTrue,
      );
      expect(
        TaskBusinessRules.isFieldEditable(TaskStatus.completed, 'title'),
        isFalse,
      );
    });
  });
}
