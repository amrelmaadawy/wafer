import 'package:dio/dio.dart';
import 'package:wafer/features/owner/reports/data/models/occupancy_report_model.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../models/defaulters_report_model.dart';
import '../models/revenue_report_model.dart';
import '../models/units_status_report_model.dart';
import '../models/contracts_report_model.dart';
import '../models/contracts_movement_report_model.dart';

abstract class OwnerReportsRemoteDataSource {
  Future<RevenueReportModel> getRevenueReport({
    int? propertyId,
    String? startDate,
    String? endDate,
  });
  Future<OccupancyReportModel> getOccupancyReport({int page = 1});
  Future<DefaultersReportModel> getDefaultersReport({int page = 1});
  Future<UnitsStatusReportModel> getUnitsStatusReport({
    int page = 1,
    int? propertyId,
    String? status,
  });
  Future<ContractsReportModel> getContractsReport({
    int page = 1,
    int? propertyId,
  });
  Future<ContractsMovementReportModel> getContractsMovementReport({int page = 1});
}

class OwnerReportsRemoteDataSourceImpl
    implements OwnerReportsRemoteDataSource {
  final Dio _dio;

  OwnerReportsRemoteDataSourceImpl(this._dio);

  @override
  Future<RevenueReportModel> getRevenueReport({
    int? propertyId,
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (propertyId != null) queryParams['property_id'] = propertyId;
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;

    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerRevenueReport}',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    if (data['data'] != null && data['data'] is Map<String, dynamic>) {
      return RevenueReportModel.fromJson(data['data']);
    }
    throw ServerException('Invalid response format');
  }

  @override
  Future<OccupancyReportModel> getOccupancyReport({int page = 1}) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerOccupancyReport}',
      queryParameters: {'page': page},
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    if (data['data'] != null && data['data'] is Map<String, dynamic>) {
      return OccupancyReportModel.fromJson(data['data']);
    }
    throw ServerException('Invalid response format');
  }

  @override
  Future<DefaultersReportModel> getDefaultersReport({int page = 1}) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerDefaultersReport}',
      queryParameters: {'page': page},
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    if (data['success'] == true && data['data'] != null) {
      return DefaultersReportModel.fromJson(data['data']);
    }
    throw ServerException(data['message'] ?? 'Invalid response format');
  }

  @override
  Future<UnitsStatusReportModel> getUnitsStatusReport({
    int page = 1,
    int? propertyId,
    String? status,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
    };
    if (propertyId != null) queryParameters['property_id'] = propertyId;
    if (status != null) queryParameters['status'] = status;

    final response = await _dio.get(
      'owner/reports/units-status',
      queryParameters: queryParameters,
    );
    final data = response.data as Map<String, dynamic>? ?? {};
    if (data['success'] == true && data['data'] != null) {
      return UnitsStatusReportModel.fromJson(data['data']);
    }
    throw ServerException(data['message'] ?? 'Invalid response format');
  }

  @override
  Future<ContractsReportModel> getContractsReport({
    int page = 1,
    int? propertyId,
  }) async {
    final queryParams = <String, dynamic>{'page': page};
    if (propertyId != null) queryParams['property_id'] = propertyId;

    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerContractsReport}',
      queryParameters: queryParams,
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    if (data['success'] == true && data['data'] != null) {
      return ContractsReportModel.fromJson(data['data']);
    }
    throw ServerException(data['message'] ?? 'Invalid response format');
  }

  @override
  Future<ContractsMovementReportModel> getContractsMovementReport({int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConstants.ownerContractsMovementReport,
        queryParameters: {'page': page},
      );
      if (response.data['success'] == true) {
        return ContractsMovementReportModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message']);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('حدث خطأ غير متوقع');
    }
  }
}
