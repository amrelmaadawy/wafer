import 'dart:async';

/// Events that the auth layer can broadcast to the rest of the app
/// (e.g. from inside a Dio interceptor where BuildContext is unavailable).
enum AuthEvent {
  /// Server returned 401 — the session token is invalid/expired.
  unauthorized,

  /// Server returned 403 — the user lacks permission.
  forbidden,
}

/// Lightweight event bus for auth-related global events.
///
/// Usage:
///   - Fire:   `AuthEventBus.fire(AuthEvent.unauthorized);`
///   - Listen: `AuthEventBus.stream.listen((event) { ... });`
class AuthEventBus {
  AuthEventBus._();

  static final StreamController<AuthEvent> _controller =
      StreamController<AuthEvent>.broadcast();

  /// Stream of auth events; multiple listeners are supported.
  static Stream<AuthEvent> get stream => _controller.stream;

  /// Dispatches an [AuthEvent] to all active listeners.
  static void fire(AuthEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  /// Call once on app teardown (if ever needed).
  static Future<void> dispose() => _controller.close();
}
