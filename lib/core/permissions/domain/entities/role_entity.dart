import 'package:equatable/equatable.dart';
import 'permission_entity.dart';

enum AppRole {
  owner,
  companyAdmin,
  branchManager,
  accountant,
  tenant,
  superAdmin,
}

class RoleEntity extends Equatable {
  final AppRole role;
  final List<PermissionEntity> permissions;

  const RoleEntity({
    required this.role,
    required this.permissions,
  });

  bool can(PermissionResource resource, PermissionAction action) {
    if (role == AppRole.superAdmin) return true;
    for (final perm in permissions) {
      if (perm.resource == resource) {
        return perm.hasAction(action);
      }
    }
    return false;
  }

  @override
  List<Object?> get props => [role, permissions];
}
