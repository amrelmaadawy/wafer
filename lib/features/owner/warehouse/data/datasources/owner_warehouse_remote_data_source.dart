import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/warehouse_items_response_model.dart';
import '../models/warehouse_summary_model.dart';
import '../models/warehouse_item_details_model.dart';
import '../models/warehouse_item_model.dart' hide WarehouseModel;
import '../models/warehouse_model.dart';
import '../models/update_warehouse_item_params_model.dart';
import '../models/warehouse_item_update_result_model.dart';
import '../../domain/entities/create_warehouse_item_params.dart';
import '../../domain/entities/create_owner_warehouse_params.dart';

import '../models/warehouse_list_response_model.dart';

abstract class OwnerWarehouseRemoteDataSource {
  Future<WarehouseListResponseModel> getWarehouses();
  Future<WarehouseModel> getWarehouseDetails(int id);
  Future<WarehouseModel> createWarehouse(CreateOwnerWarehouseParams params);
  Future<WarehouseModel> updateWarehouse(int id, Map<String, dynamic> body);
  Future<void> deleteWarehouse(int id);
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
  
  Future<WarehouseItemUpdateResultModel> updateWarehouseItem(
    UpdateWarehouseItemParamsModel params,
  );
  Future<void> deleteWarehouseItem(int id);
}

class OwnerWarehouseRemoteDataSourceImpl
    implements OwnerWarehouseRemoteDataSource {
  final Dio dio;

  OwnerWarehouseRemoteDataSourceImpl(this.dio);


  @override
  Future<WarehouseModel> createWarehouse(CreateOwnerWarehouseParams params) async {
    try {
      final response = await dio.post(
        ApiConstants.ownerWarehouses,
        data: params.toJson(),
      );
      return WarehouseModel.fromJson(response.data['data']['warehouse']);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(e.response?.data['message'] ?? 'Unknown Error');
      } else {
        throw ServerException(e.message ?? 'Unknown Error');
      }
    }
  }

  @override
  Future<WarehouseModel> updateWarehouse(int id, Map<String, dynamic> body) async {
    try {
      final response = await dio.put(
        '${ApiConstants.ownerWarehouses}/$id',
        data: body,
      );
      return WarehouseModel.fromJson(response.data['data']['warehouse']);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(e.response?.data['message'] ?? 'Unknown Error');
      } else {
        throw ServerException(e.message ?? 'Unknown Error');
      }
    }
  }

  @override
  Future<void> deleteWarehouse(int id) async {
    try {
      final response = await dio.delete('${ApiConstants.ownerWarehouses}/$id');
      if (response.data['success'] != true) {
        throw ServerException(response.data['message'] ?? 'Failed to delete warehouse');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(e.response?.data['message'] ?? 'Unknown Error');
      } else {
        throw ServerException(e.message ?? 'Unknown Error');
      }
    }
  }

  @override
  Future<WarehouseModel> getWarehouseDetails(int id) async {
    final response = await dio.get('${ApiConstants.ownerWarehouses}/$id');
    if (response.statusCode == 200) {
      if (response.data['success'] == true) {
        return WarehouseModel.fromJson(response.data['data']['warehouse']);
      } else {
        throw ServerException(response.data['message'] ?? 'Unknown error');
      }
    } else {
      throw ServerException('Failed to load warehouse details');
    }
  }

  @override
  Future<WarehouseListResponseModel> getWarehouses() async {
    try {
      final response = await dio.get(ApiConstants.ownerWarehouses);
      return WarehouseListResponseModel.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

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

  @override
  Future<WarehouseItemUpdateResultModel> updateWarehouseItem(
      UpdateWarehouseItemParamsModel params) async {
    try {
      final response = await dio.patch(
        '${ApiConstants.ownerWarehouseItems}/${params.id}',
        data: params.toJson(),
      );
      return WarehouseItemUpdateResultModel.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> deleteWarehouseItem(int id) async {
    try {
      await dio.delete('${ApiConstants.ownerWarehouseItems}/$id');
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(e.response?.data['message'] ?? 'Unknown Error');
      } else {
        throw ServerException(e.message ?? 'Unknown Error');
      }
    }
  }
}
