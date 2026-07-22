import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/deed_model.dart';

abstract class DeedsRemoteDataSource {
  Future<List<DeedModel>> getOwnerDeeds();
  Future<DeedModel> createDeed(Map<String, dynamic> body);
}

class DeedsRemoteDataSourceImpl implements DeedsRemoteDataSource {
  final Dio _dio;

  DeedsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<DeedModel>> getOwnerDeeds() async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerDeeds}',
    );

    final dataList = response.data['data'] as List<dynamic>? ?? [];
    return dataList
        .map((e) => DeedModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<DeedModel> createDeed(Map<String, dynamic> body) async {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerCreateDeed}',
      data: body,
    );

    final data = response.data['data'] as Map<String, dynamic>? ?? response.data as Map<String, dynamic>;
    return DeedModel.fromJson(data);
  }
}
