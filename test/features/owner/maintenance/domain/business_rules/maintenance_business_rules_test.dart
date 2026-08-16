import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/constants/maintenance_status.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/features/owner/maintenance/domain/business_rules/maintenance_business_rules.dart';

void main() {
  group('MaintenanceBusinessRules', () {
    test('canTransitionTo validates valid and invalid status transitions', () {
      expect(
        MaintenanceBusinessRules.canTransitionTo(
          MaintenanceStatus.new_,
          MaintenanceStatus.approved,
        ),
        isTrue,
      );
      expect(
        MaintenanceBusinessRules.canTransitionTo(
          MaintenanceStatus.new_,
          MaintenanceStatus.rejected,
        ),
        isTrue,
      );
      expect(
        MaintenanceBusinessRules.canTransitionTo(
          MaintenanceStatus.new_,
          MaintenanceStatus.executed,
        ),
        isFalse,
      );
      expect(
        MaintenanceBusinessRules.canTransitionTo(
          MaintenanceStatus.assigned,
          MaintenanceStatus.inProgress,
        ),
        isTrue,
      );
      expect(
        MaintenanceBusinessRules.canTransitionTo(
          MaintenanceStatus.rejected,
          MaintenanceStatus.approved,
        ),
        isFalse,
      );
    });

    test('validateTransition returns violation for invalid transitions and null for valid', () {
      final valid = MaintenanceBusinessRules.validateTransition(
        MaintenanceStatus.new_,
        MaintenanceStatus.approved,
      );
      expect(valid, isNull);

      final invalid = MaintenanceBusinessRules.validateTransition(
        MaintenanceStatus.rejected,
        MaintenanceStatus.inProgress,
      );
      expect(invalid, isNotNull);
      expect(invalid!.code, 'INVALID_MAINTENANCE_TRANSITION');
      expect(invalid.messageKey, LocaleKeys.brMaintenanceInvalidTransition);
    });

    test('isFieldEditable returns true only for early statuses (new, pendingSupervisor, draft)', () {
      expect(
        MaintenanceBusinessRules.isFieldEditable(MaintenanceStatus.new_, 'title'),
        isTrue,
      );
      expect(
        MaintenanceBusinessRules.isFieldEditable(MaintenanceStatus.approved, 'title'),
        isFalse,
      );
      expect(
        MaintenanceBusinessRules.isFieldEditable(MaintenanceStatus.inProgress, 'description'),
        isFalse,
      );
    });
  });
}
