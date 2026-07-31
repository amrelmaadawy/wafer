import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/maintenance_item_model.dart';
import '../models/maintenance_response_model.dart';

import '../../domain/usecases/create_owner_maintenance_use_case.dart';
import '../../domain/usecases/update_owner_maintenance_use_case.dart';
import '../../domain/usecases/approve_owner_maintenance_use_case.dart';
import '../../domain/usecases/reject_owner_maintenance_use_case.dart';
import '../../domain/usecases/assign_owner_maintenance_use_case.dart';
import '../../domain/usecases/complete_owner_maintenance_task_use_case.dart';
import '../../domain/usecases/execute_owner_maintenance_use_case.dart';
import '../../domain/usecases/verify_close_owner_maintenance_use_case.dart';
import '../models/execute_owner_maintenance_response_model.dart';
import '../models/maintenance_form_data_model.dart';

abstract class OwnerMaintenanceRemoteDataSource {
  Future<MaintenanceFormDataModel> getFormData();
  Future<MaintenanceResponseModel> getMaintenanceRequests({
    int page = 1,
    String? status,
  });
  Future<MaintenanceItemModel> getMaintenanceDetails(int id);
  Future<void> createMaintenanceRequest(CreateOwnerMaintenanceParams params);
  Future<MaintenanceItemModel> updateMaintenanceRequest(
    UpdateOwnerMaintenanceParams params,
  );
  Future<void> approveMaintenanceRequest(ApproveOwnerMaintenanceParams params);
  Future<void> rejectMaintenanceRequest(RejectOwnerMaintenanceParams params);
  Future<void> assignMaintenanceRequest(AssignOwnerMaintenanceParams params);
  Future<MaintenanceItemModel> startMaintenanceRequest(int id);
  Future<MaintenanceItemModel> completeMaintenanceTask(CompleteOwnerMaintenanceTaskParams params);
  Future<ExecuteOwnerMaintenanceResponseModel> executeMaintenanceRequest(
      ExecuteOwnerMaintenanceParams params);
  Future<MaintenanceItemModel> verifyCloseMaintenanceRequest(
      VerifyCloseOwnerMaintenanceParams params);
  Future<void> deleteMaintenanceRequest(int id);
}

class OwnerMaintenanceRemoteDataSourceImpl
    implements OwnerMaintenanceRemoteDataSource {
  final Dio _dio;

  OwnerMaintenanceRemoteDataSourceImpl(this._dio);

  @override
  Future<MaintenanceFormDataModel> getFormData() async {
    final response = await _dio.get('${ApiConstants.baseUrl}owner/maintenance-requests/form-data');
    if (response.data['success'] == true && response.data['data'] != null && response.data['data']['options'] != null) {
      return MaintenanceFormDataModel.fromJson(response.data['data']['options']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to load form data');
    }
  }

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
  Future<void> approveMaintenanceRequest(
    ApproveOwnerMaintenanceParams params,
  ) async {
    await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerMaintenanceApprove(params.id)}',
      data: params.toJson(),
    );
  }

  @override
  Future<void> deleteMaintenanceRequest(int id) async {
    await _dio.delete(
      '${ApiConstants.baseUrl}${ApiConstants.ownerMaintenanceDetails(id)}',
    );
  }

  @override
  Future<MaintenanceItemModel> completeMaintenanceTask(CompleteOwnerMaintenanceTaskParams params) async {
    final response = await _dio.patch(
      '${ApiConstants.baseUrl}${ApiConstants.ownerMaintenanceDetails(params.maintenanceId)}/tasks/${params.taskId}',
      data: params.toJson(),
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    final innerData = data['data'] as Map<String, dynamic>? ?? {};
    final itemMap =
        innerData['maintenance_request'] as Map<String, dynamic>? ?? innerData;

    return MaintenanceItemModel.fromJson(itemMap);
  }

  @override
  Future<void> rejectMaintenanceRequest(
    RejectOwnerMaintenanceParams params,
  ) async {
    await _dio.post(
      '${ApiConstants.baseUrl}owner/maintenance-requests/${params.id}/reject',
      data: params.toJson(),
    );
  }

  @override
  Future<void> assignMaintenanceRequest(
    AssignOwnerMaintenanceParams params,
  ) async {
    await _dio.post(
      '${ApiConstants.baseUrl}owner/maintenance-requests/${params.id}/assign',
      data: params.toJson(),
    );
  }

  @override
  Future<MaintenanceItemModel> startMaintenanceRequest(int id) async {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}owner/maintenance-requests/$id/start',
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final itemMap = data['maintenance_request'] as Map<String, dynamic>;
    return MaintenanceItemModel.fromJson(itemMap);
  }

  @override
  Future<ExecuteOwnerMaintenanceResponseModel> executeMaintenanceRequest(
      ExecuteOwnerMaintenanceParams params) async {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}owner/maintenance-requests/${params.id}/execute',
      data: params.toJson(),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ExecuteOwnerMaintenanceResponseModel.fromJson(data);
  }

  @override
  Future<MaintenanceItemModel> verifyCloseMaintenanceRequest(
      VerifyCloseOwnerMaintenanceParams params) async {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}owner/maintenance-requests/${params.id}/verify-close',
      data: params.toJson(),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final itemMap = data['maintenance_request'] as Map<String, dynamic>;
    return MaintenanceItemModel.fromJson(itemMap);
  }
}
