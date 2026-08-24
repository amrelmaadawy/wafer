import 'package:go_router/go_router.dart';
import 'package:wafer/features/auth/domain/entities/user_entity.dart';
import 'routes.dart';

/// Centralized authentication and authorization guard for GoRouter.
/// Returns a redirect path if the user should be redirected, null otherwise.
String? appRouterGuard({
  required GoRouterState state,
  required UserEntity? currentUser,
  required bool isAuthenticated,
  required bool isLoading,
  required bool isSessionError,
}) {
  final path = state.matchedLocation;

  // Public routes that are always accessible
  final publicRoutes = {Routes.splash, Routes.login, Routes.unsupportedAccount, Routes.changePassword};
  final isPublicRoute = publicRoutes.contains(path);

  // While loading, stay on splash
  if (isLoading) {
    return isPublicRoute ? null : Routes.splash;
  }

  // Not authenticated: redirect to login
  if (!isAuthenticated || currentUser == null) {
    if (path == Routes.splash) {
      return Routes.login;
    }
    if (isSessionError) {
      // Session error from network: stay on login (can retry)
      return isPublicRoute ? null : Routes.login;
    }
    return isPublicRoute ? null : Routes.login;
  }

  // Authenticated: don't let user navigate back to login/splash
  if (path == Routes.splash || path == Routes.login) {
    return _dashboardForUser(currentUser);
  }

  // Authenticated: check password change requirement first
  if (currentUser.requiresPasswordChange && path != Routes.changePassword) {
    return Routes.changePassword;
  }

  // Check account type for owner routes
  final accountType = currentUser.accountType;
  final isOwnerRoute = path.startsWith('/owner');

  if (isOwnerRoute && accountType != 'owner') {
    return Routes.unsupportedAccount;
  }

  // Block unsupported account types from general routes
  if (accountType != 'owner' && !path.startsWith(Routes.unsupportedAccount)) {
    return Routes.unsupportedAccount;
  }

  return null;
}

String _dashboardForUser(UserEntity user) {
  if (user.requiresPasswordChange) {
    return Routes.changePassword;
  }
  switch (user.accountType) {
    case 'owner':
      return Routes.ownerDashboard;
    default:
      return Routes.unsupportedAccount;
  }
}

/// Utility: determine correct dashboard route for authenticated user.
String dashboardRouteFor(UserEntity user) => _dashboardForUser(user);
