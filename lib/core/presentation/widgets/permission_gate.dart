import 'package:flutter/material.dart';
import '../../di/service_locator.dart';
import '../../permissions/domain/entities/permission_entity.dart';
import '../../permissions/services/permission_service.dart';

class PermissionGate extends StatelessWidget {
  final PermissionResource resource;
  final PermissionAction action;
  final Widget child;
  final Widget? fallback;

  const PermissionGate({
    super.key,
    required this.resource,
    required this.action,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final permissionService = sl<PermissionService>();
    final isAllowed = permissionService.can(resource, action);

    if (isAllowed) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}
