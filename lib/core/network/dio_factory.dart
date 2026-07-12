import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/locale_interceptor.dart';
import 'interceptors/error_interceptor.dart';

class DioFactory {
  static Dio getDio({
    required AuthInterceptor authInterceptor,
    required LocaleInterceptor localeInterceptor,
    required ErrorInterceptor errorInterceptor,
  }) {
    Dio dio = Dio();

    dio.options = BaseOptions(
      baseUrl: 'https://api.example.com/', // TODO: Move to EnvironmentConfig
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add custom interceptors
    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(localeInterceptor);
    dio.interceptors.add(errorInterceptor);

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }

    return dio;
  }
}
