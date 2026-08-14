import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _checkAuthStatusUseCase = checkAuthStatusUseCase,
       super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    
    // Ensure splash screen minimum duration (2 seconds) for branding/animation
    final stopwatch = Stopwatch()..start();
    
    final result = await _checkAuthStatusUseCase(const NoParams());

    final elapsed = stopwatch.elapsedMilliseconds;
    if (elapsed < 4200) {
      await Future.delayed(Duration(milliseconds: 4200 - elapsed));
    }

    result.fold(
      (failure) {
        // NetworkFailure/CacheFailure = connectivity issue; session may still be valid.
        // ServerFailure with no response = treat as network error too (keep session).
        if (failure is NetworkFailure || failure is CacheFailure) {
          emit(AuthSessionError(failure.message));
        } else {
          // 401/auth failures → truly unauthenticated
          emit(Unauthenticated());
        }
      },
      (user) => emit(Authenticated(user, isAutoLogin: true)),
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
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await _logoutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }
}
