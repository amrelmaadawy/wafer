import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/constants/task_status.dart';
import 'package:wafer/features/owner/tasks/domain/entities/task_entity.dart';
import 'package:wafer/features/owner/tasks/domain/entities/task_status_extension.dart';

void main() {
  group('TaskStatusExtension', () {
    test('created status enables canStart, canEdit, canDelete, canCancel', () {
      const task = TaskEntity(
        id: 1,
        title: 'Test',
        progress: 0,
        status: TaskOptionEntity(value: TaskStatus.created, label: 'Created'),
      );
      expect(task.isCreated, isTrue);
      expect(task.canStart, isTrue);
      expect(task.canEdit, isTrue);
      expect(task.canDelete, isTrue);
      expect(task.canCancel, isTrue);
      expect(task.canComplete, isFalse);
    });

    test('assigned status enables canStart, canEdit, canCancel, but not canDelete', () {
      const task = TaskEntity(
        id: 2,
        title: 'Test Assigned',
        progress: 0,
        status: TaskOptionEntity(value: TaskStatus.assigned, label: 'Assigned'),
      );
      expect(task.isAssigned, isTrue);
      expect(task.canStart, isTrue);
      expect(task.canEdit, isTrue);
      expect(task.canDelete, isFalse);
      expect(task.canCancel, isTrue);
    });

    test('in_progress status enables canComplete and canCancel, disables edit/start/delete', () {
      const task = TaskEntity(
        id: 3,
        title: 'Test In Progress',
        progress: 50,
        status: TaskOptionEntity(value: TaskStatus.inProgress, label: 'In Progress'),
      );
      expect(task.isInProgress, isTrue);
      expect(task.canComplete, isTrue);
      expect(task.canStart, isFalse);
      expect(task.canEdit, isFalse);
      expect(task.canDelete, isFalse);
      expect(task.canCancel, isTrue);
    });

    test('completed and cancelled status disable cancel, start, complete, edit, delete', () {
      const taskCompleted = TaskEntity(
        id: 4,
        title: 'Done',
        progress: 100,
        status: TaskOptionEntity(value: TaskStatus.completed, label: 'Completed'),
      );
      expect(taskCompleted.isCompleted, isTrue);
      expect(taskCompleted.canCancel, isFalse);
      expect(taskCompleted.canEdit, isFalse);
      expect(taskCompleted.canComplete, isFalse);

      const taskCancelled = TaskEntity(
        id: 5,
        title: 'Cancelled',
        progress: 0,
        status: TaskOptionEntity(value: TaskStatus.cancelled, label: 'Cancelled'),
      );
      expect(taskCancelled.isCancelled, isTrue);
      expect(taskCancelled.canCancel, isFalse);
      expect(taskCancelled.canStart, isFalse);
    });
  });
}
