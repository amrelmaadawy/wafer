import 'package:dio/dio.dart';
import '../../storage/secure_storage_service.dart';
import '../api_constants.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final Dio? _refreshDio;

  AuthInterceptor(this._secureStorage, {Dio? refreshDio})
      : _refreshDio = refreshDio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.authorizationHeader] =
          '${ApiConstants.bearerPrefix}$token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final isRetry = err.requestOptions.extra['isRetry'] == true;
    final path = err.requestOptions.path;

    final isAuthEndpoint = path.contains('login') ||
        path.contains(ApiConstants.sharedRefreshToken) ||
        path.contains(ApiConstants.sharedLogout);

    if (statusCode == 401 && !isRetry && !isAuthEndpoint) {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final client = _refreshDio ??
              Dio(
                BaseOptions(
                  baseUrl: ApiConstants.baseUrl,
                  connectTimeout: const Duration(seconds: 15),
                  receiveTimeout: const Duration(seconds: 15),
                  headers: {
                    ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
                    ApiConstants.acceptHeader: ApiConstants.applicationJson,
                  },
                ),
              );

          final refreshResponse = await client.post(
            ApiConstants.sharedRefreshToken,
            data: {'refresh_token': refreshToken},
          );

          if (refreshResponse.statusCode == 200 ||
              refreshResponse.statusCode == 201) {
            final data = refreshResponse.data;
            final newToken = data is Map ? (data['data']?['token'] ?? data['token'])?.toString() : null;
            final newRefreshToken = data is Map ? (data['data']?['refresh_token'] ?? data['refresh_token'])?.toString() : null;

            if (newToken != null && newToken.isNotEmpty) {
              await _secureStorage.saveToken(newToken);
              if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
                await _secureStorage.saveRefreshToken(newRefreshToken);
              }

              final requestOptions = err.requestOptions;
              requestOptions.headers[ApiConstants.authorizationHeader] =
                  '${ApiConstants.bearerPrefix}$newToken';
              requestOptions.extra['isRetry'] = true;

              final retryResponse = await client.request(
                requestOptions.path,
                data: requestOptions.data,
                queryParameters: requestOptions.queryParameters,
                options: Options(
                  method: requestOptions.method,
                  headers: requestOptions.headers,
                  extra: requestOptions.extra,
                  responseType: requestOptions.responseType,
                  contentType: requestOptions.contentType,
                ),
              );

              return handler.resolve(retryResponse);
            }
          }
        } catch (_) {
          // Token refresh failed; proceed to error chain for forced logout
        }
      }
    }

    handler.next(err);
  }
}
