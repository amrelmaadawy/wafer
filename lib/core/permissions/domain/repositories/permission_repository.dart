import '../entities/permission_entity.dart';
import '../entities/role_entity.dart';

abstract class PermissionRepository {
  RoleEntity get currentRole;
  bool can(PermissionResource resource, PermissionAction action);
  void setRole(RoleEntity role);
  void setRoleFromAccountType(String accountType, {List<PermissionEntity>? customPermissions});
}
