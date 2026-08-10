import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/locale_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/connectivity_interceptor.dart';
import 'interceptors/cache_interceptor_config.dart';
import 'connectivity/network_info.dart';
import 'api_constants.dart';

class DioFactory {
  static Dio getDio({
    required AuthInterceptor authInterceptor,
    required LocaleInterceptor localeInterceptor,
    required ErrorInterceptor errorInterceptor,
    required NetworkInfo networkInfo,
  }) {
    Dio dio = Dio();

    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15), // tightened for mobile
      receiveTimeout: const Duration(seconds: 30), // tightened for mobile
      headers: {
        ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
        ApiConstants.acceptHeader: ApiConstants.applicationJson,
      },
    );

    // 1. Connectivity check (first — rejects immediately if offline)
    dio.interceptors.add(ConnectivityInterceptor(networkInfo));

    // 2. Auth token injection
    dio.interceptors.add(authInterceptor);

    // 3. Accept-Language header
    dio.interceptors.add(localeInterceptor);

    // 4. API Response Caching
    dio.interceptors.add(CacheInterceptorConfig.buildInterceptor());

    // 5. 401/403 global error handling
    dio.interceptors.add(errorInterceptor);

    // 6. Debug logging (debug only)
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }

    return dio;
  }
}
