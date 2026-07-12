import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioFactory {
  static Dio getDio() {
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

    // TODO: Add AuthInterceptor, LocaleInterceptor, ErrorInterceptor

    return dio;
  }
}
