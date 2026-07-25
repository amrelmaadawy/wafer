import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../../domain/entities/properties_pagination_meta_entity.dart';
import '../models/unit_model.dart';
import '../models/unit_full_details_model.dart';

abstract class UnitsRemoteDataSource {
  Future<({List<UnitModel> items, PropertiesPaginationMetaEntity meta})> getPropertyUnits(
    int propertyId, {
    int page = 1,
    String? search,
    String? unitStatus,
    String? unitType,
  });
  Future<int> createDraftUnit(int propertyId);
  Future<void> autoSaveUnit(int propertyId, int unitId, Map<String, dynamic> data);
  Future<UnitFullDetailsModel> getUnitDetails(int propertyId, int unitId);
  Future<void> publishUnit(int propertyId, int unitId);
}

class UnitsRemoteDataSourceImpl implements UnitsRemoteDataSource {
  final Dio _dio;

  UnitsRemoteDataSourceImpl(this._dio);

  @override
  Future<({List<UnitModel> items, PropertiesPaginationMetaEntity meta})> getPropertyUnits(
    int propertyId, {
    int page = 1,
    String? search,
    String? unitStatus,
    String? unitType,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'page': page,
      if (search != null && search.isNotEmpty) 'search': search,
      if (unitStatus != null && unitStatus != 'all') 'unit_status': unitStatus,
      if (unitType != null && unitType != 'all') 'unit_type': unitType,
    };

    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerPropertyUnits(propertyId)}',
      queryParameters: queryParameters,
    );

    final dataList = response.data['data'] as List<dynamic>? ?? [];
    final items = dataList
        .map((e) => UnitModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final metaJson = response.data['meta'];
    final meta = metaJson != null 
        ? PropertiesPaginationMetaEntity(
            currentPage: metaJson['current_page'] as int? ?? 1,
            lastPage: metaJson['last_page'] as int? ?? 1,
            perPage: metaJson['per_page'] as int? ?? items.length,
            total: metaJson['total'] as int? ?? items.length,
          )
        : PropertiesPaginationMetaEntity(
            currentPage: page,
            lastPage: page,
            perPage: items.length,
            total: items.length,
          );
          
    return (items: items, meta: meta);
  }

  @override
  Future<int> createDraftUnit(int propertyId) async {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerCreateDraftUnit(propertyId)}',
    );

    final data = response.data['data'] as Map<String, dynamic>? ?? response.data as Map<String, dynamic>;
    return data['id'] as int? ?? data['unit_id'] as int? ?? 0;
  }

  @override
  Future<void> autoSaveUnit(int propertyId, int unitId, Map<String, dynamic> data) async {
    await _dio.patch(
      '${ApiConstants.baseUrl}${ApiConstants.ownerAutoSaveUnit(propertyId, unitId)}',
      data: data,
    );
  }

  @override
  Future<UnitFullDetailsModel> getUnitDetails(int propertyId, int unitId) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerShowUnit(propertyId, unitId)}',
    );
    return UnitFullDetailsModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> publishUnit(int propertyId, int unitId) async {
    await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerPublishUnit(propertyId, unitId)}',
    );
  }
}
