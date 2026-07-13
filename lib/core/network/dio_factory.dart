import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/locale_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'api_constants.dart';

class DioFactory {
  static Dio getDio({
    required AuthInterceptor authInterceptor,
    required LocaleInterceptor localeInterceptor,
    required ErrorInterceptor errorInterceptor,
  }) {
    Dio dio = Dio();

    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
        ApiConstants.acceptHeader: ApiConstants.applicationJson,
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
