import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/unit_model.dart';

abstract class UnitsRemoteDataSource {
  Future<List<UnitModel>> getPropertyUnits(int propertyId);
  Future<int> createDraftUnit(int propertyId);
  Future<void> autoSaveUnit(int propertyId, int unitId, Map<String, dynamic> data);
  Future<UnitModel> getUnitDetails(int propertyId, int unitId);
  Future<void> publishUnit(int propertyId, int unitId);
}

class UnitsRemoteDataSourceImpl implements UnitsRemoteDataSource {
  final Dio _dio;

  UnitsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<UnitModel>> getPropertyUnits(int propertyId) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerPropertyUnits(propertyId)}',
    );

    final dataList = response.data['data'] as List<dynamic>? ?? [];
    return dataList
        .map((e) => UnitModel.fromJson(e as Map<String, dynamic>))
        .toList();
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
  Future<UnitModel> getUnitDetails(int propertyId, int unitId) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerShowUnit(propertyId, unitId)}',
    );

    final data = response.data['data'] as Map<String, dynamic>? ?? response.data as Map<String, dynamic>;
    return UnitModel.fromJson(data);
  }

  @override
  Future<void> publishUnit(int propertyId, int unitId) async {
    await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerPublishUnit(propertyId, unitId)}',
    );
  }
}
