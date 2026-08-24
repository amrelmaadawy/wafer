import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/warehouse_items_response_model.dart';
import '../models/warehouse_summary_model.dart';
import '../models/warehouse_item_details_model.dart';
import '../models/warehouse_item_model.dart';
import '../../domain/entities/create_warehouse_item_params.dart';

abstract class OwnerWarehouseRemoteDataSource {
  Future<WarehouseSummaryModel> getWarehouseSummary();
  Future<WarehouseItemsResponseModel> getWarehouseItems({
    int page = 1,
    String? search,
    String? category,
    int? warehouseId,
    String? status,
  });
  Future<WarehouseItemModel> createWarehouseItem(
    CreateWarehouseItemParams params,
  );

  Future<WarehouseItemDetailsModel> getWarehouseItemDetails(int id);
}

class OwnerWarehouseRemoteDataSourceImpl
    implements OwnerWarehouseRemoteDataSource {
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
        'warehouse_id': ?warehouseId,
        if (status != null && status.isNotEmpty) 'status': status,
      };

      final response = await dio.get(
        ApiConstants.ownerWarehouseItems,
        queryParameters: queryParameters,
      );
      return WarehouseItemsResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(e.response?.data['message'] ?? 'Unknown Error');
      } else {
        throw ServerException(e.message ?? 'Unknown Error');
      }
    }
  }

  @override
  Future<WarehouseItemModel> createWarehouseItem(
    CreateWarehouseItemParams params,
  ) async {
    try {
      final response = await dio.post(
        ApiConstants.ownerWarehouseItems,
        data: params.toJson(),
      );
      return WarehouseItemModel.fromJson(response.data['data']['item']);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(e.response?.data['message'] ?? 'Unknown Error');
      } else {
        throw ServerException(e.message ?? 'Unknown Error');
      }
    }
  }

  @override
  Future<WarehouseItemDetailsModel> getWarehouseItemDetails(int id) async {
    try {
      final response = await dio.get('${ApiConstants.ownerWarehouseItems}/$id');
      return WarehouseItemDetailsModel.fromJson(response.data['data']['item']);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(e.response?.data['message'] ?? 'Unknown Error');
      } else {
        throw ServerException(e.message ?? 'Unknown Error');
      }
    }
  }
}
