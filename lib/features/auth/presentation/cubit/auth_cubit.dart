import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/connectivity/auth_event_bus.dart';
import '../../../../core/permissions/services/permission_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final PermissionService _permissionService;

  StreamSubscription<AuthEvent>? _authEventSubscription;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required PermissionService permissionService,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _checkAuthStatusUseCase = checkAuthStatusUseCase,
        _permissionService = permissionService,
        super(AuthInitial()) {
    listenToAuthEvents();
  }

  void listenToAuthEvents() {
    _authEventSubscription?.cancel();
    _authEventSubscription = AuthEventBus.stream.listen((event) {
      if (event == AuthEvent.unauthorized) {
        _handleSessionExpired();
      } else if (event == AuthEvent.forbidden) {
        emit(const AuthForbidden());
      }
    });
  }

  Future<void> _handleSessionExpired() async {
    await _logoutUseCase(const NoParams());
    emit(const AuthSessionExpired());
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    final stopwatch = Stopwatch()..start();
    final result = await _checkAuthStatusUseCase(const NoParams());

    final elapsed = stopwatch.elapsedMilliseconds;
    if (elapsed < 4200) {
      await Future.delayed(Duration(milliseconds: 4200 - elapsed));
    }

    result.fold(
      (failure) {
        if (failure is NetworkFailure || failure is CacheFailure) {
          emit(AuthSessionError(failure.message));
        } else {
          emit(Unauthenticated());
        }
      },
      (user) {
        _permissionService.updateFromUser(user);
        emit(Authenticated(user, isAutoLogin: true));
      },
    );
  }

  Future<void> login({
    required String username,
    required String password,
    required String deviceName,
    required String deviceToken,
    required bool rememberMe,
  }) async {
    emit(AuthLoading());
    final result = await _loginUseCase(
      LoginParams(
        username: username,
        password: password,
        deviceName: deviceName,
        deviceToken: deviceToken,
        rememberMe: rememberMe,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        _permissionService.updateFromUser(user);
        emit(Authenticated(user));
      },
    );
  }

  void confirmPasswordChanged() {
    final currentState = state;
    if (currentState is Authenticated) {
      final user = currentState.user;
      final updatedUser = UserEntity(
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        avatar: user.avatar,
        token: user.token,
        accountType: user.accountType,
        userType: user.userType,
        clientType: user.clientType,
        isTenantAdmin: user.isTenantAdmin,
        tenantId: user.tenantId,
        tenantName: user.tenantName,
        requiresPasswordChange: false,
      );
      emit(Authenticated(updatedUser));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await _logoutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authEventSubscription?.cancel();
    return super.close();
  }
}
