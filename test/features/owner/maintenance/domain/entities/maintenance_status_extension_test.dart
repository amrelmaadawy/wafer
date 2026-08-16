import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/constants/maintenance_status.dart';
import 'package:wafer/features/owner/maintenance/domain/entities/maintenance_item_entity.dart';
import 'package:wafer/features/owner/maintenance/domain/entities/maintenance_status_extension.dart';

void main() {
  group('MaintenanceStatusExtension', () {
    test('new or pending_supervisor enables approve, reject, edit, delete', () {
      const itemNew = MaintenanceItemEntity(id: 1, status: MaintenanceStatus.new_);
      expect(itemNew.canApprove, isTrue);
      expect(itemNew.canReject, isTrue);
      expect(itemNew.canEdit, isTrue);
      expect(itemNew.canDelete, isTrue);
      expect(itemNew.canAssign, isFalse);

      const itemPending = MaintenanceItemEntity(id: 2, status: MaintenanceStatus.pendingSupervisor);
      expect(itemPending.canApprove, isTrue);
      expect(itemPending.canReject, isTrue);
      expect(itemPending.canEdit, isTrue);
      expect(itemPending.canDelete, isTrue);
    });

    test('approved enables assign and delete, disables edit', () {
      const item = MaintenanceItemEntity(id: 3, status: MaintenanceStatus.approved);
      expect(item.canApprove, isFalse);
      expect(item.canAssign, isTrue);
      expect(item.canEdit, isFalse);
      expect(item.canDelete, isTrue);
    });

    test('assigned enables start', () {
      const item = MaintenanceItemEntity(id: 4, status: MaintenanceStatus.assigned);
      expect(item.canStart, isTrue);
      expect(item.canEdit, isFalse);
      expect(item.canDelete, isFalse);
    });

    test('in_progress enables execute', () {
      const item = MaintenanceItemEntity(id: 5, status: MaintenanceStatus.inProgress);
      expect(item.canExecute, isTrue);
      expect(item.canStart, isFalse);
    });

    test('executed enables verify_close', () {
      const item = MaintenanceItemEntity(id: 6, status: MaintenanceStatus.executed);
      expect(item.canVerifyClose, isTrue);
    });

    test('closed enables forward', () {
      const item = MaintenanceItemEntity(id: 7, status: MaintenanceStatus.closed);
      expect(item.canForward, isTrue);
    });
  });
}
