import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/defaulter_model.dart';
import '../models/occupancy_property_model.dart';
import '../models/revenue_entry_model.dart';

abstract class OwnerReportsRemoteDataSource {
  Future<List<RevenueEntryModel>> getRevenueReport();
  Future<List<OccupancyPropertyModel>> getOccupancyReport();
  /// TODO: implement when endpoint is ready (owner/reports/defaulters)
  Future<List<DefaulterModel>> getDefaultersReport();
}

class OwnerReportsRemoteDataSourceImpl
    implements OwnerReportsRemoteDataSource {
  final Dio _dio;

  OwnerReportsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<RevenueEntryModel>> getRevenueReport() async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerRevenueReport}',
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    final list = data['data'] as List<dynamic>? ?? [];

    final models = list
        .whereType<Map<String, dynamic>>()
        .map((json) => RevenueEntryModel.fromJson(json))
        .toList();

    return models.reversed.toList();
  }

  @override
  Future<List<OccupancyPropertyModel>> getOccupancyReport() async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerOccupancyReport}',
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    final list = data['data'] as List<dynamic>? ?? [];

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
}
