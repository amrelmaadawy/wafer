import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/owner_dashboard_model.dart';

abstract class OwnerDashboardRemoteDataSource {
  Future<OwnerDashboardModel> getDashboardStats();
}

class OwnerDashboardRemoteDataSourceImpl implements OwnerDashboardRemoteDataSource {
  final Dio _dio;

  OwnerDashboardRemoteDataSourceImpl(this._dio);

  @override
  Future<OwnerDashboardModel> getDashboardStats() async {
    final response = await _dio.get('${ApiConstants.baseUrl}owner/dashboard');
    final data = response.data['data'] as Map<String, dynamic>;
    return OwnerDashboardModel.fromJson(data);
  }
}
