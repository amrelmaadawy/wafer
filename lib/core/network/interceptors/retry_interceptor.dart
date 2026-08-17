import 'dart:async';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;
  final List<Duration> retryDelays;

  RetryInterceptor(
    this._dio, {
    this.maxRetries = 2,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
    ],
  });

  static const String _retryCountKey = 'retry_count';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final isGetMethod = options.method.toUpperCase() == 'GET';

    final isTimeout = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout;

    if (!isGetMethod || !isTimeout) {
      return handler.next(err);
    }

    final currentRetry = (options.extra[_retryCountKey] as int?) ?? 0;

    if (currentRetry >= maxRetries) {
      return handler.next(err);
    }

    final nextRetry = currentRetry + 1;
    final delay = currentRetry < retryDelays.length
        ? retryDelays[currentRetry]
        : retryDelays.last;

    await Future.delayed(delay);

    if (options.cancelToken?.isCancelled ?? false) {
      return handler.next(err);
    }

    options.extra[_retryCountKey] = nextRetry;

    try {
      final response = await _dio.fetch(options);
      return handler.resolve(response);
    } on DioException catch (retryErr) {
      return handler.next(retryErr);
    } catch (e) {
      return handler.next(err);
    }
  }
}
