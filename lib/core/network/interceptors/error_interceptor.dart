import 'package:dio/dio.dart';
import '../connectivity/auth_event_bus.dart';

/// Global Dio error interceptor.
///
/// Responsibilities:
/// - Fires [AuthEvent.unauthorized] via [AuthEventBus] on 401 so the app
///   can force-logout without needing a BuildContext here.
/// - Fires [AuthEvent.forbidden] on 403 for permission-denied handling.
/// - Passes all errors down the interceptor chain unchanged.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      // Token expired or invalid — trigger global logout flow.
      AuthEventBus.fire(AuthEvent.unauthorized);
    } else if (statusCode == 403) {
      // Access forbidden — notify the app if needed.
      AuthEventBus.fire(AuthEvent.forbidden);
    }

    // Always forward the error so repositories / cubits can handle it.
    handler.next(err);
  }
}
