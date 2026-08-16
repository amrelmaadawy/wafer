import '../../../../../core/constants/maintenance_status.dart';
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

  bool get canVerifyClose => status == MaintenanceStatus.executed;

  bool get canForward => status == MaintenanceStatus.closed;

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
