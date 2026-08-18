import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/core/network/interceptors/auth_interceptor.dart';
import 'package:wafer/core/storage/secure_storage_service.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}
class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  late MockSecureStorageService mockStorage;
  late AuthInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockStorage = MockSecureStorageService();
    interceptor = AuthInterceptor(mockStorage);
  });

  group('AuthInterceptor', () {
    test('onRequest adds Authorization header when token exists', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => 'valid_token_123');
      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], equals('Bearer valid_token_123'));
      verify(() => handler.next(options)).called(1);
    });

    test('onRequest does not add Authorization header when token is null', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => null);
      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers.containsKey('Authorization'), isFalse);
      verify(() => handler.next(options)).called(1);
    });

    test('onError passes through error when status is not 401', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
      );
      final handler = MockErrorInterceptorHandler();

      await interceptor.onError(dioException, handler);

      verify(() => handler.next(dioException)).called(1);
    });
  });
}
