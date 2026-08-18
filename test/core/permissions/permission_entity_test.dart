import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/permissions/domain/entities/permission_entity.dart';
import 'package:wafer/core/permissions/domain/entities/role_entity.dart';

void main() {
  group('PermissionEntity', () {
    test('hasAction returns true when action is allowed', () {
      const permission = PermissionEntity(
        resource: PermissionResource.property,
        allowedActions: [PermissionAction.view, PermissionAction.create],
      );

      expect(permission.hasAction(PermissionAction.view), isTrue);
      expect(permission.hasAction(PermissionAction.create), isTrue);
      expect(permission.hasAction(PermissionAction.delete), isFalse);
    });

    test('equality and props work properly', () {
      const p1 = PermissionEntity(
        resource: PermissionResource.finance,
        allowedActions: [PermissionAction.view],
      );
      const p2 = PermissionEntity(
        resource: PermissionResource.finance,
        allowedActions: [PermissionAction.view],
      );

      expect(p1, equals(p2));
    });
  });

  group('RoleEntity', () {
    test('superAdmin always has permission for all resources and actions', () {
      const role = RoleEntity(
        role: AppRole.superAdmin,
        permissions: [],
      );

      expect(role.can(PermissionResource.property, PermissionAction.delete), isTrue);
      expect(role.can(PermissionResource.finance, PermissionAction.reverse), isTrue);
    });

    test('can returns true only for matching resource and action', () {
      const role = RoleEntity(
        role: AppRole.owner,
        permissions: [
          PermissionEntity(
            resource: PermissionResource.property,
            allowedActions: [PermissionAction.view, PermissionAction.create],
          ),
          PermissionEntity(
            resource: PermissionResource.finance,
            allowedActions: [PermissionAction.view],
          ),
        ],
      );

      expect(role.can(PermissionResource.property, PermissionAction.view), isTrue);
      expect(role.can(PermissionResource.property, PermissionAction.create), isTrue);
      expect(role.can(PermissionResource.property, PermissionAction.delete), isFalse);
      expect(role.can(PermissionResource.finance, PermissionAction.view), isTrue);
      expect(role.can(PermissionResource.finance, PermissionAction.create), isFalse);
      expect(role.can(PermissionResource.contract, PermissionAction.view), isFalse);
    });
  });
}
