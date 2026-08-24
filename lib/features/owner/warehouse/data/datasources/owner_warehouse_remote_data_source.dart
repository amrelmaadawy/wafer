import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/warehouse_items_response_model.dart';
import '../models/warehouse_summary_model.dart';

abstract class OwnerWarehouseRemoteDataSource {
  Future<WarehouseSummaryModel> getWarehouseSummary();
  Future<WarehouseItemsResponseModel> getWarehouseItems({
    int page = 1,
    String? search,
    String? category,
    int? warehouseId,
    String? status,
  });
}

class OwnerWarehouseRemoteDataSourceImpl implements OwnerWarehouseRemoteDataSource {
  final Dio dio;

  OwnerWarehouseRemoteDataSourceImpl(this.dio);

  @override
  Future<WarehouseSummaryModel> getWarehouseSummary() async {
    final response = await dio.get('${ApiConstants.baseUrl}owner/warehouse');
    return WarehouseSummaryModel.fromJson(response.data['data']);
  }

  @override
  Future<WarehouseItemsResponseModel> getWarehouseItems({
    int page = 1,
    String? search,
    String? category,
    int? warehouseId,
    String? status,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null && category.isNotEmpty) 'category': category,
        if (warehouseId != null) 'warehouse_id': warehouseId,
        if (status != null && status.isNotEmpty) 'status': status,
      };
      
      final response = await dio.get(
        ApiConstants.ownerWarehouseItems,
        queryParameters: queryParameters,
      );
      return WarehouseItemsResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          e.response?.data['message'] ?? 'Unknown Error',
        );
      } else {
        throw ServerException(e.message ?? 'Unknown Error');
      }
    }
  }
}
