import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/notifications_response_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationsResponseModel> getNotifications({int page = 1});
  Future<int> getUnreadNotificationsCount();
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final Dio _dio;

  NotificationsRemoteDataSourceImpl(this._dio);

  @override
  Future<NotificationsResponseModel> getNotifications({int page = 1}) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.sharedNotifications}',
      queryParameters: {'page': page},
    );
    final data = response.data as Map<String, dynamic>;
    return NotificationsResponseModel.fromJson(data);
  }

  @override
  Future<int> getUnreadNotificationsCount() async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.sharedUnreadCount}',
    );
    final dataMap = response.data as Map<String, dynamic>? ?? {};
    final innerData = dataMap['data'] as Map<String, dynamic>? ?? {};
    return innerData['count'] as int? ?? 0;
  }
}
