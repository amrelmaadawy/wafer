import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Check for 401 Unauthorized
    if (err.response?.statusCode == 401) {
      debugPrint('Unauthorized! Force logout or token refresh needed.');
      // TODO: Dispatch global event to trigger logout UI and clear storage
    }
    
    // Check for 403 Forbidden
    if (err.response?.statusCode == 403) {
      debugPrint('Forbidden! User does not have permissions.');
    }

    handler.next(err);
  }
}
