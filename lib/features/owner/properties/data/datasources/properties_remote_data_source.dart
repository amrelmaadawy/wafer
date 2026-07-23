import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/properties_pagination_meta_model.dart';
import '../models/properties_stats_model.dart';
import '../models/property_details_model.dart';
import '../models/property_form_data_model.dart';
import '../models/property_list_item_model.dart';

abstract class PropertiesRemoteDataSource {
  Future<
      ({
        List<PropertyListItemModel> items,
        PropertiesPaginationMetaModel meta,
        PropertiesStatsModel stats,
      })> getProperties(Map<String, dynamic> queryParams);

  Future<PropertyFormOptionsModel> getFormOptions();

  Future<PropertyFormDataModel> getPropertyFormData();

  Future<PropertyDetailsModel> getPropertyDetails(int propertyId);

  Future<int> createDraftProperty(Map<String, dynamic> body);

  Future<void> autoSavePropertyStep({
    required int propertyId,
    required String step,
    required Map<String, dynamic> data,
  });

  Future<void> syncOwners(int propertyId, List<Map<String, dynamic>> owners);

  Future<String> uploadTempFile(String filePath);

  Future<void> addUploadedImagePath(int propertyId, String imagePath);

  Future<void> publishProperty(int propertyId);

  Future<int> cloneProperty(int propertyId);
  Future<void> makeRepresentative(int propertyId, Map<String, dynamic> body);
  Future<void> removeRepresentative(int propertyId);
  Future<void> deleteProperty(int propertyId);
  Future<void> patchProperty(int propertyId, Map<String, dynamic> data);
}

class PropertiesRemoteDataSourceImpl implements PropertiesRemoteDataSource {
  final Dio _dio;

  PropertiesRemoteDataSourceImpl(this._dio);

  @override
  Future<
      ({
        List<PropertyListItemModel> items,
        PropertiesPaginationMetaModel meta,
        PropertiesStatsModel stats,
      })> getProperties(Map<String, dynamic> queryParams) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerProperties}',
      queryParameters: queryParams,
    );

    final responseData = response.data;
    final List<dynamic> dataList = responseData['data'] as List<dynamic>? ?? [];
    final items = dataList
        .map((e) => PropertyListItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final metaJson = responseData['pagination'] as Map<String, dynamic>? ?? responseData['meta'] as Map<String, dynamic>? ?? {};
    final meta = PropertiesPaginationMetaModel.fromJson(metaJson);

    final statsJson = responseData['stats'] as Map<String, dynamic>? ?? {};
    final stats = PropertiesStatsModel.fromJson(statsJson);

    return (items: items, meta: meta, stats: stats);
  }

  @override
  Future<PropertyFormOptionsModel> getFormOptions() async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerFormData}',
    );

    final data = response.data['data'] as Map<String, dynamic>? ?? response.data as Map<String, dynamic>;
    final optionsData = data['options'] as Map<String, dynamic>? ?? {};
    return PropertyFormOptionsModel.fromJson(optionsData);
  }

  @override
  Future<PropertyFormDataModel> getPropertyFormData() async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerFormData}',
    );

    final data = response.data['data'] as Map<String, dynamic>? ?? response.data as Map<String, dynamic>;
    return PropertyFormDataModel.fromJson(data);
  }

  @override
  Future<PropertyDetailsModel> getPropertyDetails(int propertyId) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerPropertyDetails(propertyId)}',
    );

    final data = response.data['data'] as Map<String, dynamic>? ?? response.data as Map<String, dynamic>;
    return PropertyDetailsModel.fromJson(data);
  }

  @override
  Future<int> createDraftProperty(Map<String, dynamic> body) async {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerCreateDraftProperty}',
      data: body,
    );

    final data = response.data['data'] as Map<String, dynamic>? ?? response.data as Map<String, dynamic>;
    return data['id'] as int? ?? data['property_id'] as int? ?? 0;
  }

  @override
  Future<void> autoSavePropertyStep({
    required int propertyId,
    required String step,
    required Map<String, dynamic> data,
  }) async {
    await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerAutoSaveProperty(propertyId)}',
      data: {
        'step': step,
        ...data,
      },
    );
  }

  @override
  Future<void> syncOwners(int propertyId, List<Map<String, dynamic>> owners) async {
    await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerSyncOwners(propertyId)}',
      data: {'owners': owners},
    );
  }

  @override
  Future<String> uploadTempFile(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    final response = await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerUploadTempFile}',
      data: formData,
    );

    final data = response.data['data'] as Map<String, dynamic>? ?? response.data as Map<String, dynamic>;
    return data['temp_path']?.toString() ?? data['path']?.toString() ?? '';
  }

  @override
  Future<void> addUploadedImagePath(int propertyId, String imagePath) async {
    await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerAutoSaveProperty(propertyId)}',
      data: {
        'step': 'images',
        'image_path': imagePath,
      },
    );
  }

  @override
  Future<void> publishProperty(int propertyId) async {
    await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerPublishProperty(propertyId)}',
    );
  }

  @override
  Future<int> cloneProperty(int propertyId) async {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerCloneProperty(propertyId)}',
    );
    final data = response.data['data'] as Map<String, dynamic>? ?? response.data as Map<String, dynamic>;
    return data['id'] as int? ?? data['new_id'] as int? ?? 0;
  }

  @override
  Future<void> makeRepresentative(int propertyId, Map<String, dynamic> body) async {
    await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.ownerMakeRepresentative(propertyId)}',
      data: body,
    );
  }

  @override
  Future<void> removeRepresentative(int propertyId) async {
    await _dio.delete(
      '${ApiConstants.baseUrl}${ApiConstants.ownerRemoveRepresentative(propertyId)}',
    );
  }

  @override
  Future<void> deleteProperty(int propertyId) async {
    await _dio.delete(
      '${ApiConstants.baseUrl}${ApiConstants.ownerDeleteProperty(propertyId)}',
    );
  }

  @override
  Future<void> patchProperty(int propertyId, Map<String, dynamic> data) async {
    await _dio.patch(
      '${ApiConstants.baseUrl}${ApiConstants.ownerPatchProperty(propertyId)}',
      data: data,
    );
  }
}
