import '../../domain/entities/permission_entity.dart';

class PermissionModel extends PermissionEntity {
  const PermissionModel({
    required super.resource,
    required super.allowedActions,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    final resourceStr = json['resource'] as String? ?? '';
    final actionsList = json['actions'] as List<dynamic>? ?? [];

    final resource = _parseResource(resourceStr);
    final allowedActions = actionsList
        .map((a) => _parseAction(a.toString()))
        .whereType<PermissionAction>()
        .toList();

    return PermissionModel(
      resource: resource,
      allowedActions: allowedActions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resource': resource.name,
      'actions': allowedActions.map((a) => a.name).toList(),
    };
  }

  static PermissionResource _parseResource(String value) {
    switch (value.toLowerCase()) {
      case 'property':
      case 'properties':
        return PermissionResource.property;
      case 'unit':
      case 'units':
        return PermissionResource.unit;
      case 'contract':
      case 'contracts':
        return PermissionResource.contract;
      case 'finance':
      case 'accounting':
        return PermissionResource.finance;
      case 'maintenance':
      case 'maintenance_requests':
        return PermissionResource.maintenance;
      case 'report':
      case 'reports':
        return PermissionResource.report;
      case 'task':
      case 'tasks':
        return PermissionResource.task;
      case 'legal_case':
      case 'legal_cases':
      case 'legalcase':
        return PermissionResource.legalCase;
      case 'deed':
      case 'deeds':
        return PermissionResource.deed;
      case 'notification':
      case 'notifications':
        return PermissionResource.notification;
      default:
        return PermissionResource.property;
    }
  }

  static PermissionAction? _parseAction(String value) {
    switch (value.toLowerCase()) {
      case 'view':
      case 'read':
      case 'show':
      case 'list':
        return PermissionAction.view;
      case 'create':
      case 'store':
      case 'add':
        return PermissionAction.create;
      case 'edit':
      case 'update':
      case 'patch':
        return PermissionAction.edit;
      case 'approve':
        return PermissionAction.approve;
      case 'reverse':
        return PermissionAction.reverse;
      case 'delete':
      case 'destroy':
        return PermissionAction.delete;
      case 'export':
      case 'download':
        return PermissionAction.export;
      default:
        return null;
    }
  }
}
