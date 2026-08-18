import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/permissions/data/repositories/permission_repository_impl.dart';
import 'package:wafer/core/permissions/domain/entities/permission_entity.dart';
import 'package:wafer/core/permissions/domain/entities/role_entity.dart';

void main() {
  late PermissionRepositoryImpl repository;

  setUp(() {
    repository = PermissionRepositoryImpl();
  });

  group('PermissionRepositoryImpl', () {
    test('initializes with default owner role', () {
      expect(repository.currentRole.role, equals(AppRole.owner));
      expect(repository.can(PermissionResource.property, PermissionAction.view), isTrue);
      expect(repository.can(PermissionResource.contract, PermissionAction.delete), isFalse);
      expect(repository.can(PermissionResource.finance, PermissionAction.reverse), isFalse);
    });

    test('setRole updates the role', () {
      const customRole = RoleEntity(
        role: AppRole.tenant,
        permissions: [
          PermissionEntity(
            resource: PermissionResource.maintenance,
            allowedActions: [PermissionAction.create],
          ),
        ],
      );

      repository.setRole(customRole);
      expect(repository.currentRole.role, equals(AppRole.tenant));
      expect(repository.can(PermissionResource.maintenance, PermissionAction.create), isTrue);
      expect(repository.can(PermissionResource.property, PermissionAction.view), isFalse);
    });

    test('setRoleFromAccountType sets appropriate defaults', () {
      repository.setRoleFromAccountType('tenant');
      expect(repository.currentRole.role, equals(AppRole.tenant));

      repository.setRoleFromAccountType('company');
      expect(repository.currentRole.role, equals(AppRole.companyAdmin));

      repository.setRoleFromAccountType('super_admin');
      expect(repository.currentRole.role, equals(AppRole.superAdmin));
    });
  });
}
