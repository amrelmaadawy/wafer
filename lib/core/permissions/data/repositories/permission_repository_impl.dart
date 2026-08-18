import '../../domain/entities/permission_entity.dart';
import '../../domain/entities/role_entity.dart';
import '../../domain/repositories/permission_repository.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  RoleEntity _currentRole = defaultOwnerRole;

  @override
  RoleEntity get currentRole => _currentRole;

  @override
  bool can(PermissionResource resource, PermissionAction action) {
    return _currentRole.can(resource, action);
  }

  @override
  void setRole(RoleEntity role) {
    _currentRole = role;
  }

  @override
  void setRoleFromAccountType(
    String accountType, {
    List<PermissionEntity>? customPermissions,
  }) {
    switch (accountType.toLowerCase()) {
      case 'owner':
        _currentRole = customPermissions != null && customPermissions.isNotEmpty
            ? RoleEntity(role: AppRole.owner, permissions: customPermissions)
            : defaultOwnerRole;
        break;
      case 'company':
      case 'company_admin':
        _currentRole = customPermissions != null && customPermissions.isNotEmpty
            ? RoleEntity(role: AppRole.companyAdmin, permissions: customPermissions)
            : defaultCompanyAdminRole;
        break;
      case 'tenant':
        _currentRole = customPermissions != null && customPermissions.isNotEmpty
            ? RoleEntity(role: AppRole.tenant, permissions: customPermissions)
            : defaultTenantRole;
        break;
      case 'system':
      case 'super_admin':
        _currentRole = const RoleEntity(role: AppRole.superAdmin, permissions: []);
        break;
      default:
        _currentRole = defaultOwnerRole;
    }
  }

  static const RoleEntity defaultOwnerRole = RoleEntity(
    role: AppRole.owner,
    permissions: [
      PermissionEntity(
        resource: PermissionResource.property,
        allowedActions: [
          PermissionAction.view,
          PermissionAction.create,
          PermissionAction.edit,
          PermissionAction.delete,
          PermissionAction.export,
        ],
      ),
      PermissionEntity(
        resource: PermissionResource.unit,
        allowedActions: [
          PermissionAction.view,
          PermissionAction.create,
          PermissionAction.edit,
          PermissionAction.delete,
          PermissionAction.export,
        ],
      ),
      PermissionEntity(
        resource: PermissionResource.contract,
        allowedActions: [
          PermissionAction.view,
          PermissionAction.create,
          PermissionAction.edit,
          PermissionAction.export,
        ],
      ),
      PermissionEntity(
        resource: PermissionResource.finance,
        allowedActions: [
          PermissionAction.view,
          PermissionAction.create,
          PermissionAction.edit,
          PermissionAction.export,
        ],
      ),
      PermissionEntity(
        resource: PermissionResource.maintenance,
        allowedActions: [
          PermissionAction.view,
          PermissionAction.create,
          PermissionAction.edit,
          PermissionAction.approve,
          PermissionAction.export,
        ],
      ),
      PermissionEntity(
        resource: PermissionResource.report,
        allowedActions: [
          PermissionAction.view,
          PermissionAction.export,
        ],
      ),
      PermissionEntity(
        resource: PermissionResource.task,
        allowedActions: [
          PermissionAction.view,
          PermissionAction.create,
          PermissionAction.edit,
          PermissionAction.export,
        ],
      ),
      PermissionEntity(
        resource: PermissionResource.legalCase,
        allowedActions: [
          PermissionAction.view,
          PermissionAction.export,
        ],
      ),
      PermissionEntity(
        resource: PermissionResource.deed,
        allowedActions: [
          PermissionAction.view,
          PermissionAction.create,
          PermissionAction.edit,
          PermissionAction.delete,
          PermissionAction.export,
        ],
      ),
      PermissionEntity(
        resource: PermissionResource.notification,
        allowedActions: [
          PermissionAction.view,
          PermissionAction.edit,
          PermissionAction.delete,
        ],
      ),
    ],
  );

  static const RoleEntity defaultCompanyAdminRole = RoleEntity(
    role: AppRole.companyAdmin,
    permissions: [
      PermissionEntity(
        resource: PermissionResource.property,
        allowedActions: PermissionAction.values,
      ),
      PermissionEntity(
        resource: PermissionResource.unit,
        allowedActions: PermissionAction.values,
      ),
      PermissionEntity(
        resource: PermissionResource.contract,
        allowedActions: PermissionAction.values,
      ),
      PermissionEntity(
        resource: PermissionResource.finance,
        allowedActions: PermissionAction.values,
      ),
      PermissionEntity(
        resource: PermissionResource.maintenance,
        allowedActions: PermissionAction.values,
      ),
      PermissionEntity(
        resource: PermissionResource.report,
        allowedActions: [PermissionAction.view, PermissionAction.export],
      ),
      PermissionEntity(
        resource: PermissionResource.task,
        allowedActions: PermissionAction.values,
      ),
      PermissionEntity(
        resource: PermissionResource.legalCase,
        allowedActions: PermissionAction.values,
      ),
      PermissionEntity(
        resource: PermissionResource.deed,
        allowedActions: PermissionAction.values,
      ),
      PermissionEntity(
        resource: PermissionResource.notification,
        allowedActions: PermissionAction.values,
      ),
    ],
  );

  static const RoleEntity defaultTenantRole = RoleEntity(
    role: AppRole.tenant,
    permissions: [
      PermissionEntity(
        resource: PermissionResource.contract,
        allowedActions: [PermissionAction.view, PermissionAction.export],
      ),
      PermissionEntity(
        resource: PermissionResource.finance,
        allowedActions: [PermissionAction.view, PermissionAction.create, PermissionAction.export],
      ),
      PermissionEntity(
        resource: PermissionResource.maintenance,
        allowedActions: [PermissionAction.view, PermissionAction.create],
      ),
      PermissionEntity(
        resource: PermissionResource.notification,
        allowedActions: [PermissionAction.view, PermissionAction.edit],
      ),
    ],
  );
}
