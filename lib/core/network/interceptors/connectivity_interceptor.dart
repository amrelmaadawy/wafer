import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../connectivity/network_info.dart';
import '../../error/failures.dart';
import '../../localization/locale_keys.dart';

/// Interceptor that checks internet connectivity BEFORE every request.
///
/// If the device has no internet, the request is immediately rejected with a
/// [DioException] wrapping a [NetworkFailure], so repositories catch it
/// through their existing error handlers without any changes needed.
class ConnectivityInterceptor extends Interceptor {
  final NetworkInfo _networkInfo;

  ConnectivityInterceptor(this._networkInfo);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: LocaleKeys.errorsNetworkError.tr(),
        ),
        true, // callFollowingErrorInterceptor = true
      );
      return;
    }

    handler.next(options);
  }
}
