import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/core/permissions/domain/entities/permission_entity.dart';
import 'package:wafer/core/permissions/domain/repositories/permission_repository.dart';
import 'package:wafer/core/permissions/services/permission_service_impl.dart';
import 'package:wafer/features/auth/domain/entities/user_entity.dart';

class MockPermissionRepository extends Mock implements PermissionRepository {}

void main() {
  late MockPermissionRepository mockRepository;
  late PermissionServiceImpl service;

  setUp(() {
    mockRepository = MockPermissionRepository();
    service = PermissionServiceImpl(mockRepository);
  });

  group('PermissionServiceImpl', () {
    test('can delegates to repository', () {
      when(() => mockRepository.can(PermissionResource.property, PermissionAction.view))
          .thenReturn(true);

      final result = service.can(PermissionResource.property, PermissionAction.view);
      expect(result, isTrue);
      verify(() => mockRepository.can(PermissionResource.property, PermissionAction.view)).called(1);
    });

    test('updateFromUser calls setRoleFromAccountType on repository', () {
      const user = UserEntity(
        id: '1',
        name: 'Test Owner',
        email: 'owner@test.com',
        accountType: 'owner',
      );

      when(() => mockRepository.setRoleFromAccountType('owner', customPermissions: null))
          .thenReturn(null);

      service.updateFromUser(user);
      verify(() => mockRepository.setRoleFromAccountType('owner', customPermissions: null)).called(1);
    });
  });
}
