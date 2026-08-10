import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';


class CacheInterceptorConfig {
  static late HiveCacheStore cacheStore;
  static late CacheOptions cacheOptions;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    cacheStore = HiveCacheStore(
      dir.path,
      hiveBoxName: 'codra_cache_v1',
    );

    cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.request, // Default policy
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      cipher: null,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );
  }

  static DioCacheInterceptor buildInterceptor() {
    return DioCacheInterceptor(options: cacheOptions);
  }

  static Future<void> clearCache() async {
    await cacheStore.clean();
  }
}
