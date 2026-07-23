import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../../domain/entities/deeds_query_filter_entity.dart';
import '../../domain/entities/deeds_response_entity.dart';
import '../models/deed_model.dart';
import '../models/deeds_pagination_meta_model.dart';

abstract class DeedsRemoteDataSource {
  Future<DeedsResponseEntity> getDeeds({required DeedsQueryFilterEntity filter});
}

class DeedsRemoteDataSourceImpl implements DeedsRemoteDataSource {
  final Dio _dio;

  DeedsRemoteDataSourceImpl(this._dio);

  @override
  Future<DeedsResponseEntity> getDeeds({required DeedsQueryFilterEntity filter}) async {
    final response = await _dio.get(
      ApiConstants.ownerDeeds,
      queryParameters: filter.toMap(),
    );

    final data = response.data['data'] as List;
    final meta = response.data['pagination'];

    return DeedsResponseEntity(
      items: data.map((e) => DeedModel.fromJson(e)).toList(),
      meta: DeedsPaginationMetaModel.fromJson(meta),
    );
  }
}
