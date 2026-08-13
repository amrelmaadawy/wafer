import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../../../../../core/network/interceptors/cache_interceptor_config.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/owner_dashboard_model.dart';

abstract class OwnerDashboardRemoteDataSource {
  Future<OwnerDashboardModel> getDashboardStats({
    bool forceRefresh = false,
    CancelToken? cancelToken,
  });
}

class OwnerDashboardRemoteDataSourceImpl
    implements OwnerDashboardRemoteDataSource {
  final Dio _dio;

  OwnerDashboardRemoteDataSourceImpl(this._dio);

  @override
  Future<OwnerDashboardModel> getDashboardStats({
    bool forceRefresh = false,
    CancelToken? cancelToken,
  }) async {
    final cacheOptions = CacheInterceptorConfig.cacheOptions.copyWith(
      policy: forceRefresh
          ? CachePolicy.refreshForceCache
          : CachePolicy.request,
    );

    final response = await _dio.get(
      ApiConstants.ownerDashboard,
      options: cacheOptions.toOptions(),
      cancelToken: cancelToken,
    );
    final responseBody = response.data;
    final rawData = responseBody is Map ? responseBody['data'] : null;
    final data = rawData is Map
        ? Map<String, dynamic>.from(rawData)
        : <String, dynamic>{};
    return OwnerDashboardModel.fromJson(data);
  }
}
