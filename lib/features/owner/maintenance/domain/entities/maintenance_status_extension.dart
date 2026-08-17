import '../../../../../core/constants/maintenance_status.dart';
import '../../../../../core/localization/locale_keys.dart';
import 'maintenance_item_entity.dart';

extension MaintenanceStatusExtension on MaintenanceItemEntity {
  bool get isNew =>
      status == MaintenanceStatus.new_ ||
      status == MaintenanceStatus.pendingSupervisor;

  bool get canApprove => isNew;

  bool get canReject => isNew;

  bool get canAssign => status == MaintenanceStatus.approved;

  bool get canStart => status == MaintenanceStatus.assigned;

  bool get canExecute => status == MaintenanceStatus.inProgress;

  bool get canComplete => canExecute;

  bool get canVerifyClose => status == MaintenanceStatus.executed;

  bool get canForward => status == MaintenanceStatus.closed;

  bool get isForwarded => status == MaintenanceStatus.forwarded;

  bool get isTerminalState =>
      status == MaintenanceStatus.rejected ||
      status == MaintenanceStatus.cancelled;

  int get workflowStepIndex {
    switch (status) {
      case MaintenanceStatus.new_:
      case MaintenanceStatus.pendingSupervisor:
      case MaintenanceStatus.draft:
        return 0;
      case MaintenanceStatus.approved:
        return 1;
      case MaintenanceStatus.assigned:
        return 2;
      case MaintenanceStatus.inProgress:
        return 3;
      case MaintenanceStatus.executed:
        return 4;
      case MaintenanceStatus.closed:
      case MaintenanceStatus.forwarded:
        return 5;
      default:
        return -1;
    }
  }

  String get pendingActionLocaleKey {
    if (canApprove) return LocaleKeys.maintenancePendingApproval;
    if (canAssign) return LocaleKeys.maintenancePendingAssignment;
    if (canStart) return LocaleKeys.maintenancePendingStart;
    if (canExecute) return LocaleKeys.maintenancePendingExecution;
    if (canVerifyClose) return LocaleKeys.maintenancePendingVerification;
    if (canForward) return LocaleKeys.maintenancePendingForward;
    return '';
  }

  bool get canEdit => [
        MaintenanceStatus.new_,
        MaintenanceStatus.pendingSupervisor,
        MaintenanceStatus.draft,
      ].contains(status);

  bool get canDelete => [
        MaintenanceStatus.new_,
        MaintenanceStatus.pendingSupervisor,
        MaintenanceStatus.approved,
        MaintenanceStatus.draft,
      ].contains(status);
}

