import 'package:dio/dio.dart';

import '../../../../../core/network/api_constants.dart';
import '../models/warehouse_summary_model.dart';

abstract class OwnerWarehouseRemoteDataSource {
  Future<WarehouseSummaryModel> getWarehouseSummary();
}

class OwnerWarehouseRemoteDataSourceImpl implements OwnerWarehouseRemoteDataSource {
  final Dio dio;

  OwnerWarehouseRemoteDataSourceImpl(this.dio);

  @override
  Future<WarehouseSummaryModel> getWarehouseSummary() async {
    final response = await dio.get('${ApiConstants.baseUrl}owner/warehouse');
    return WarehouseSummaryModel.fromJson(response.data['data']);
  }
}
