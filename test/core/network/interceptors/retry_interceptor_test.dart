import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/core/network/interceptors/retry_interceptor.dart';

class MockDio extends Mock implements Dio {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}
class FakeRequestOptions extends Fake implements RequestOptions {}
class FakeResponse extends Fake implements Response<dynamic> {}

void main() {
  late MockDio mockDio;
  late MockErrorInterceptorHandler mockHandler;
  late RetryInterceptor retryInterceptor;

  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
    registerFallbackValue(FakeResponse());
  });

  setUp(() {
    mockDio = MockDio();
    mockHandler = MockErrorInterceptorHandler();
    retryInterceptor = RetryInterceptor(
      mockDio,
      maxRetries: 2,
      retryDelays: const [Duration(milliseconds: 1), Duration(milliseconds: 1)],
    );
  });

  test('passes through non-GET requests without retrying', () async {
    final options = RequestOptions(path: '/test', method: 'POST');
    final err = DioException(
      requestOptions: options,
      type: DioExceptionType.connectionTimeout,
    );

    await retryInterceptor.onError(err, mockHandler);

    verify(() => mockHandler.next(err)).called(1);
  });

  test('passes through non-timeout errors without retrying', () async {
    final options = RequestOptions(path: '/test', method: 'GET');
    final err = DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
    );

    await retryInterceptor.onError(err, mockHandler);

    verify(() => mockHandler.next(err)).called(1);
  });

  test('retries GET requests on connectionTimeout and resolves on success', () async {
    final options = RequestOptions(path: '/test', method: 'GET');
    final err = DioException(
      requestOptions: options,
      type: DioExceptionType.connectionTimeout,
    );
    final response = Response(requestOptions: options, statusCode: 200);

    when(() => mockDio.fetch(options)).thenAnswer((_) async => response);

    await retryInterceptor.onError(err, mockHandler);

    verify(() => mockDio.fetch(options)).called(1);
    verify(() => mockHandler.resolve(response)).called(1);
  });
}
