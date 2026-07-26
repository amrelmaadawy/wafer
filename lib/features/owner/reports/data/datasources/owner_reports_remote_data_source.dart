import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../models/defaulter_model.dart';
import '../models/occupancy_property_model.dart';
import '../models/revenue_report_model.dart';
import '../models/units_status_report_model.dart';

abstract class OwnerReportsRemoteDataSource {
  Future<RevenueReportModel> getRevenueReport({
    int? propertyId,
    String? startDate,
    String? endDate,
  });
  Future<List<OccupancyPropertyModel>> getOccupancyReport();
  /// TODO: implement when endpoint is ready (owner/reports/defaulters)
  Future<List<DefaulterModel>> getDefaultersReport();
  Future<UnitsStatusReportModel> getUnitsStatusReport({
    int page = 1,
    int? propertyId,
    String? status,
  });
}

class OwnerReportsRemoteDataSourceImpl
    implements OwnerReportsRemoteDataSource {
  final Dio _dio;

  OwnerReportsRemoteDataSourceImpl(this._dio);

  List<dynamic> _extractList(dynamic dataField) {
    if (dataField is List) return dataField;
    if (dataField is Map) {
      if (dataField.containsKey('items') && dataField['items'] is List) {
        return dataField['items'] as List;
      }
      if (dataField.containsKey('data') && dataField['data'] is List) {
        return dataField['data'] as List;
      }
      // If no explicit keys, try to find the first array in the map
      for (var value in dataField.values) {
        if (value is List) return value;
      }
    }
    return [];
  }

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
  Future<List<OccupancyPropertyModel>> getOccupancyReport() async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerOccupancyReport}',
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    final list = _extractList(data['data']);

    return list
        .whereType<Map<String, dynamic>>()
        .map((json) => OccupancyPropertyModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<DefaulterModel>> getDefaultersReport() async {
    // TODO: replace with real endpoint when ready
    // final response = await _dio.get(
    //   '${ApiConstants.baseUrl}${ApiConstants.ownerDefaultersReport}',
    // );
    // final data = response.data as Map<String, dynamic>? ?? {};
    // final list = data['data'] as List<dynamic>? ?? [];
    // return list
    //     .whereType<Map<String, dynamic>>()
    //     .map((json) => DefaulterModel.fromJson(json))
    //     .toList();
    return [];
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
    } else {
      throw ServerException(data['message']?.toString() ?? 'Server error');
    }
  }
}
