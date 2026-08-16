import '../../../../../core/constants/task_status.dart';
import 'task_entity.dart';

extension TaskStatusExtension on TaskEntity {
  String get statusValue => status?.value.toLowerCase().trim() ?? '';

  bool get isCreated => statusValue == TaskStatus.created;

  bool get isAssigned => statusValue == TaskStatus.assigned;

  bool get isInProgress => statusValue == TaskStatus.inProgress;

  bool get isCompleted => statusValue == TaskStatus.completed;

  bool get isCancelled => statusValue == TaskStatus.cancelled;

  bool get isOverdue => (dates?.isOverdue ?? false) || statusValue == TaskStatus.overdue;

  bool get canEdit => [
        TaskStatus.created,
        TaskStatus.assigned,
      ].contains(statusValue);

  bool get canDelete => [
        TaskStatus.created,
      ].contains(statusValue);

  bool get canStart => statusValue == TaskStatus.assigned || statusValue == TaskStatus.created;

  bool get canComplete => statusValue == TaskStatus.inProgress;

  bool get canCancel => ![
        TaskStatus.completed,
        TaskStatus.cancelled,
      ].contains(statusValue);
}
