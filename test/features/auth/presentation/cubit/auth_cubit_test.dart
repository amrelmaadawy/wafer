import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/core/network/connectivity/auth_event_bus.dart';
import 'package:wafer/core/permissions/services/permission_service.dart';
import 'package:wafer/core/usecases/usecase.dart';
import 'package:wafer/features/auth/domain/entities/user_entity.dart';
import 'package:wafer/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:wafer/features/auth/domain/usecases/login_usecase.dart';
import 'package:wafer/features/auth/domain/usecases/logout_usecase.dart';
import 'package:wafer/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:wafer/features/auth/presentation/cubit/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockCheckAuthStatusUseCase extends Mock implements CheckAuthStatusUseCase {}
class MockPermissionService extends Mock implements PermissionService {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;
  late MockPermissionService mockPermissionService;
  late AuthCubit authCubit;

  const tUser = UserEntity(
    id: '1',
    name: 'Test Owner',
    email: 'owner@test.com',
    accountType: 'owner',
    requiresPasswordChange: true,
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const LoginParams(
        username: '',
        password: '',
        deviceName: '',
        deviceToken: '',
        rememberMe: false,
      ),
    );
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
    mockPermissionService = MockPermissionService();

    authCubit = AuthCubit(
      loginUseCase: mockLoginUseCase,
      logoutUseCase: mockLogoutUseCase,
      checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
      permissionService: mockPermissionService,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    test('initial state is AuthInitial', () {
      expect(authCubit.state, equals(AuthInitial()));
    });

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Authenticated] when login is successful',
      build: () {
        when(() => mockLoginUseCase(any())).thenAnswer((_) async => const Right(tUser));
        when(() => mockPermissionService.updateFromUser(tUser)).thenReturn(null);
        return authCubit;
      },
      act: (cubit) => cubit.login(
        username: 'owner@test.com',
        password: 'password',
        deviceName: 'Test Phone',
        deviceToken: 'tok123',
        rememberMe: true,
      ),
      expect: () => [
        AuthLoading(),
        const Authenticated(tUser),
      ],
      verify: (_) {
        verify(() => mockPermissionService.updateFromUser(tUser)).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'confirmPasswordChanged updates requiresPasswordChange to false in Authenticated state',
      build: () {
        when(() => mockLoginUseCase(any())).thenAnswer((_) async => const Right(tUser));
        when(() => mockPermissionService.updateFromUser(tUser)).thenReturn(null);
        return authCubit;
      },
      seed: () => const Authenticated(tUser),
      act: (cubit) => cubit.confirmPasswordChanged(),
      expect: () => [
        const Authenticated(
          UserEntity(
            id: '1',
            name: 'Test Owner',
            email: 'owner@test.com',
            accountType: 'owner',
            requiresPasswordChange: false,
          ),
        ),
      ],
    );

    test('listens to AuthEvent.forbidden and emits AuthForbidden', () async {
      final states = <AuthState>[];
      final subscription = authCubit.stream.listen(states.add);

      AuthEventBus.fire(AuthEvent.forbidden);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states, contains(const AuthForbidden()));
      await subscription.cancel();
    });

    test('listens to AuthEvent.unauthorized and handles session expiry', () async {
      when(() => mockLogoutUseCase(any())).thenAnswer((_) async => const Right(null));

      final states = <AuthState>[];
      final subscription = authCubit.stream.listen(states.add);

      AuthEventBus.fire(AuthEvent.unauthorized);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states, contains(const AuthSessionExpired()));
      verify(() => mockLogoutUseCase(any())).called(1);
      await subscription.cancel();
    });
  });
}
