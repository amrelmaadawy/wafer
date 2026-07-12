import 'package:dio/dio.dart';
import '../../storage/cache_helper.dart';

class LocaleInterceptor extends Interceptor {
  final CacheHelper _cacheHelper;

  LocaleInterceptor(this._cacheHelper);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final lang = _cacheHelper.getLanguage();
    options.headers['Accept-Language'] = lang;
    handler.next(options);
  }
}
