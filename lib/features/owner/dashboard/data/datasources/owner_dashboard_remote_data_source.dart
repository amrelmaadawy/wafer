import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../../../../../core/network/interceptors/cache_interceptor_config.dart';
import '../models/owner_dashboard_model.dart';

abstract class OwnerDashboardRemoteDataSource {
  Future<OwnerDashboardModel> getDashboardStats({bool forceRefresh = false});
}

class OwnerDashboardRemoteDataSourceImpl
    implements OwnerDashboardRemoteDataSource {
  final Dio _dio;

  OwnerDashboardRemoteDataSourceImpl(this._dio);

  @override
  Future<OwnerDashboardModel> getDashboardStats({bool forceRefresh = false}) async {
    final cacheOptions = CacheInterceptorConfig.cacheOptions.copyWith(
      policy: forceRefresh ? CachePolicy.refreshForceCache : CachePolicy.request,
    );

    final response = await _dio.get(
      'owner/dashboard',
      options: cacheOptions.toOptions(),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return OwnerDashboardModel.fromJson(data);
  }
}
