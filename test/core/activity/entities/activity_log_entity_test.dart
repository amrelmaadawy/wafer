import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/activity/entities/activity_log_entity.dart';

void main() {
  group('ActivityActionType', () {
    test('fromString accurately categorizes actions', () {
      expect(ActivityActionType.fromString('created'), equals(ActivityActionType.created));
      expect(ActivityActionType.fromString('approved'), equals(ActivityActionType.approved));
      expect(ActivityActionType.fromString('rejected'), equals(ActivityActionType.rejected));
      expect(ActivityActionType.fromString('assigned'), equals(ActivityActionType.assigned));
      expect(ActivityActionType.fromString('updated'), equals(ActivityActionType.updated));
      expect(ActivityActionType.fromString('completed'), equals(ActivityActionType.completed));
      expect(ActivityActionType.fromString('cancelled'), equals(ActivityActionType.cancelled));
      expect(ActivityActionType.fromString('unknown_action'), equals(ActivityActionType.other));
      expect(ActivityActionType.fromString(null), equals(ActivityActionType.other));
    });
  });

  group('ActivityLogEntity', () {
    test('inferred factory infers action type correctly', () {
      final entity = ActivityLogEntity.inferred(
        id: '1',
        action: 'approved',
        notes: 'Approved by manager',
        oldStatus: 'pending',
        newStatus: 'approved',
        performedByName: 'Admin',
        createdAt: '2026-08-17 10:45',
      );

      expect(entity.id, equals('1'));
      expect(entity.action, equals('approved'));
      expect(entity.type, equals(ActivityActionType.approved));
      expect(entity.props, contains('Approved by manager'));
    });

    test('respects explicit type in const constructor', () {
      const entity = ActivityLogEntity(
        id: '2',
        action: 'custom',
        type: ActivityActionType.completed,
      );

      expect(entity.type, equals(ActivityActionType.completed));
    });
  });
}
