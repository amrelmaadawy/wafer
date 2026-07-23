import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../../domain/entities/deeds_query_filter_entity.dart';
import '../../domain/entities/deeds_response_entity.dart';
import '../models/deed_model.dart';
import '../models/deeds_pagination_meta_model.dart';

import '../../domain/usecases/create_deed_use_case.dart';

abstract class DeedsRemoteDataSource {
  Future<DeedsResponseEntity> getDeeds({required DeedsQueryFilterEntity filter});
  Future<void> createDeed({required AddNewDeedParams params});
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
  @override
  Future<void> createDeed({required AddNewDeedParams params}) async {
    final Map<String, dynamic> data = {
      'name': params.name,
      'branch_id': params.branchId,
      'document_type': params.documentType,
      'document_number': params.documentNumber,
      'document_date': params.documentDate,
      'area': params.area,
      if (params.city != null && params.city!.isNotEmpty) 'city': params.city,
      if (params.district != null && params.district!.isNotEmpty) 'district': params.district,
      if (params.region != null && params.region!.isNotEmpty) 'region': params.region,
      if (params.streetName != null && params.streetName!.isNotEmpty) 'street_name': params.streetName,
      if (params.buildingNumber != null && params.buildingNumber!.isNotEmpty) 'building_number': params.buildingNumber,
      if (params.postalCode != null && params.postalCode!.isNotEmpty) 'postal_code': params.postalCode,
      if (params.notes != null && params.notes!.isNotEmpty) 'notes': params.notes,
    };

    if (params.documentAttachment != null) {
      data['document_attachment'] = await MultipartFile.fromFile(
        params.documentAttachment!.path,
        filename: params.documentAttachment!.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(data);

    await _dio.post(
      ApiConstants.ownerDeeds,
      data: formData,
    );
  }
}
