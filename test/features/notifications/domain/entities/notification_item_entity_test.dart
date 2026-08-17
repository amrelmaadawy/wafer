import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/notifications/data/models/notification_item_model.dart';
import 'package:wafer/features/notifications/domain/entities/notification_item_entity.dart';

void main() {
  group('NotificationCategory', () {
    test('fromType maps strings to correct categories', () {
      expect(
        NotificationCategory.fromType('payment'),
        equals(NotificationCategory.financial),
      );
      expect(
        NotificationCategory.fromType('invoice'),
        equals(NotificationCategory.financial),
      );
      expect(
        NotificationCategory.fromType('lease'),
        equals(NotificationCategory.contracts),
      );
      expect(
        NotificationCategory.fromType('contract_expiry'),
        equals(NotificationCategory.contracts),
      );
      expect(
        NotificationCategory.fromType('maintenance'),
        equals(NotificationCategory.maintenance),
      );
      expect(
        NotificationCategory.fromType('task_assigned'),
        equals(NotificationCategory.tasks),
      );
      expect(
        NotificationCategory.fromType('legal_case_update'),
        equals(NotificationCategory.legal),
      );
      expect(
        NotificationCategory.fromType('system_alert'),
        equals(NotificationCategory.system),
      );
      expect(
        NotificationCategory.fromType(null),
        equals(NotificationCategory.system),
      );
    });
  });

  group('NotificationItemModel.fromJson', () {
    test('parses entityId, entityType, priority correctly', () {
      final json = {
        'id': 'notif-1',
        'title': 'Overdue Installment',
        'body': 'Installment #452 is overdue',
        'type': 'payment',
        'created_at': '2026-08-17T10:00:00Z',
        'read_at': null,
        'data': {
          'id': 452,
          'priority': 'high',
          'model': 'installment',
        },
      };

      final model = NotificationItemModel.fromJson(json);

      expect(model.id, equals('notif-1'));
      expect(model.title, equals('Overdue Installment'));
      expect(model.type, equals('payment'));
      expect(model.category, equals(NotificationCategory.financial));
      expect(model.priority, equals('high'));
      expect(model.entityId, equals('452'));
      expect(model.entityType, equals('installment'));
      expect(model.isRead, isFalse);
    });
  });
}
