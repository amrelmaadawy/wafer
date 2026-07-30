import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/maintenance_item_model.dart';
import '../models/maintenance_response_model.dart';

import '../../domain/usecases/create_owner_maintenance_use_case.dart';
import '../../domain/usecases/update_owner_maintenance_use_case.dart';

abstract class OwnerMaintenanceRemoteDataSource {
  Future<MaintenanceResponseModel> getMaintenanceRequests({
    int page = 1,
    String? status,
  });
  Future<MaintenanceItemModel> getMaintenanceDetails(int id);
  Future<void> createMaintenanceRequest(CreateOwnerMaintenanceParams params);
  Future<MaintenanceItemModel> updateMaintenanceRequest(
    UpdateOwnerMaintenanceParams params,
  );
  Future<void> deleteMaintenanceRequest(int id);
}

class OwnerMaintenanceRemoteDataSourceImpl
    implements OwnerMaintenanceRemoteDataSource {
  final Dio _dio;

  OwnerMaintenanceRemoteDataSourceImpl(this._dio);

  @override
  Future<MaintenanceResponseModel> getMaintenanceRequests({
    int page = 1,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{'page': page};
    if (status != null && status != 'all' && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerMaintenance}',
      queryParameters: queryParams,
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    return MaintenanceResponseModel.fromJson(data);
  }

  @override
  Future<MaintenanceItemModel> getMaintenanceDetails(int id) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerMaintenanceDetails(id)}',
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    final innerData = data['data'] as Map<String, dynamic>? ?? {};

    Map<String, dynamic> itemMap = {};
    if (innerData['maintenance_requests'] is Map<String, dynamic>) {
      final requestsMap =
          innerData['maintenance_requests'] as Map<String, dynamic>;
      if (requestsMap['data'] is List &&
          (requestsMap['data'] as List).isNotEmpty) {
        final firstItem = (requestsMap['data'] as List).first;
        if (firstItem is Map<String, dynamic>) itemMap = firstItem;
      }
    } else if (innerData['maintenance_request'] is Map<String, dynamic>) {
      itemMap = innerData['maintenance_request'] as Map<String, dynamic>;
    } else if (innerData['data'] is Map<String, dynamic>) {
      itemMap = innerData['data'] as Map<String, dynamic>;
    } else {
      itemMap = innerData;
    }

    return MaintenanceItemModel.fromJson(itemMap);
  }

  @override
  Future<void> createMaintenanceRequest(
    CreateOwnerMaintenanceParams params,
  ) async {
    await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerMaintenance}',
      data: params.toJson(),
    );
  }

  @override
  Future<MaintenanceItemModel> updateMaintenanceRequest(
    UpdateOwnerMaintenanceParams params,
  ) async {
    final response = await _dio.patch(
      '${ApiConstants.baseUrl}${ApiConstants.ownerMaintenanceDetails(params.id)}',
      data: params.toJson(),
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    final innerData = data['data'] as Map<String, dynamic>? ?? {};

    Map<String, dynamic> itemMap = {};
    if (innerData['maintenance_request'] is Map<String, dynamic>) {
      itemMap = innerData['maintenance_request'] as Map<String, dynamic>;
    } else {
      itemMap = innerData;
    }

    return MaintenanceItemModel.fromJson(itemMap);
  }

  @override
  Future<void> deleteMaintenanceRequest(int id) async {
    await _dio.delete(
      '${ApiConstants.baseUrl}${ApiConstants.ownerMaintenanceDetails(id)}',
    );
  }
}
