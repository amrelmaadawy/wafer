import 'package:equatable/equatable.dart';

enum ActivityActionType {
  created,
  approved,
  rejected,
  assigned,
  updated,
  completed,
  cancelled,
  other;

  static ActivityActionType fromString(String? action) {
    if (action == null) return ActivityActionType.other;
    final lower = action.toLowerCase().trim();
    switch (lower) {
      case 'created':
      case 'create':
      case 'opened':
        return ActivityActionType.created;
      case 'approved':
      case 'approve':
      case 'accepted':
        return ActivityActionType.approved;
      case 'rejected':
      case 'reject':
      case 'declined':
        return ActivityActionType.rejected;
      case 'assigned':
      case 'assign':
      case 'forwarded':
        return ActivityActionType.assigned;
      case 'updated':
      case 'update':
      case 'modified':
      case 'edit':
      case 'edited':
        return ActivityActionType.updated;
      case 'completed':
      case 'complete':
      case 'executed':
      case 'closed':
      case 'resolved':
        return ActivityActionType.completed;
      case 'cancelled':
      case 'cancel':
      case 'deleted':
        return ActivityActionType.cancelled;
      default:
        return ActivityActionType.other;
    }
  }
}

class ActivityLogEntity extends Equatable {
  final String? id;
  final String? action;
  final String? actionLabel;
  final String? performedByName;
  final String? notes;
  final String? oldStatus;
  final String? newStatus;
  final String? oldStatusLabel;
  final String? newStatusLabel;
  final String? createdAt;
  final ActivityActionType type;

  const ActivityLogEntity({
    this.id,
    this.action,
    this.actionLabel,
    this.performedByName,
    this.notes,
    this.oldStatus,
    this.newStatus,
    this.oldStatusLabel,
    this.newStatusLabel,
    this.createdAt,
    this.type = ActivityActionType.other,
  });

  factory ActivityLogEntity.inferred({
    String? id,
    String? action,
    String? actionLabel,
    String? performedByName,
    String? notes,
    String? oldStatus,
    String? newStatus,
    String? oldStatusLabel,
    String? newStatusLabel,
    String? createdAt,
    ActivityActionType? type,
  }) {
    return ActivityLogEntity(
      id: id,
      action: action,
      actionLabel: actionLabel,
      performedByName: performedByName,
      notes: notes,
      oldStatus: oldStatus,
      newStatus: newStatus,
      oldStatusLabel: oldStatusLabel,
      newStatusLabel: newStatusLabel,
      createdAt: createdAt,
      type: type ?? ActivityActionType.fromString(action),
    );
  }

  @override
  List<Object?> get props => [
        id,
        action,
        actionLabel,
        performedByName,
        notes,
        oldStatus,
        newStatus,
        oldStatusLabel,
        newStatusLabel,
        createdAt,
        type,
      ];
}
