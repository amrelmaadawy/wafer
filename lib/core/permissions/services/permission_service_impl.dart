import '../../../features/auth/domain/entities/user_entity.dart';
import '../domain/entities/permission_entity.dart';
import '../domain/entities/role_entity.dart';
import '../domain/repositories/permission_repository.dart';
import 'permission_service.dart';

class PermissionServiceImpl implements PermissionService {
  final PermissionRepository _repository;

  PermissionServiceImpl(this._repository);

  @override
  RoleEntity get currentRole => _repository.currentRole;

  @override
  bool can(PermissionResource resource, PermissionAction action) {
    return _repository.can(resource, action);
  }

  @override
  void updateFromUser(
    UserEntity user, {
    List<PermissionEntity>? customPermissions,
  }) {
    _repository.setRoleFromAccountType(
      user.accountType,
      customPermissions: customPermissions,
    );
  }

  @override
  void setRole(RoleEntity role) {
    _repository.setRole(role);
  }
}
