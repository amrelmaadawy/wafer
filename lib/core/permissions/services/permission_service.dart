import '../../../features/auth/domain/entities/user_entity.dart';
import '../domain/entities/permission_entity.dart';
import '../domain/entities/role_entity.dart';

abstract class PermissionService {
  RoleEntity get currentRole;
  bool can(PermissionResource resource, PermissionAction action);
  void updateFromUser(UserEntity user, {List<PermissionEntity>? customPermissions});
  void setRole(RoleEntity role);
}
