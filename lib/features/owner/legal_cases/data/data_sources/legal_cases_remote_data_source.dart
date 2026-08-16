import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../models/legal_case_form_data_model.dart';
import '../models/legal_cases_list_response_model.dart';
import '../models/legal_case_item_model.dart';
import '../../domain/entities/legal_cases_filter_params.dart';
import '../../domain/usecases/create_legal_case_use_case.dart';
import '../../domain/usecases/update_legal_case_use_case.dart';
import '../../domain/usecases/add_legal_case_stage_use_case.dart';

abstract class LegalCasesRemoteDataSource {
  Future<LegalCaseFormDataModel> getLegalCaseFormData();
  Future<LegalCasesListResponseModel> getLegalCasesList({
    LegalCasesFilterParams params = const LegalCasesFilterParams(),
  });
  Future<LegalCaseItemModel> getLegalCaseDetails(int id);
  Future<LegalCaseItemModel> createLegalCase(CreateLegalCaseParams params);
  Future<LegalCaseItemModel> updateLegalCase(UpdateLegalCaseParams params);
  Future<void> deleteLegalCase(int id);
  Future<LegalCaseItemModel> addLegalCaseStage(AddStageParams params);
  Future<void> deleteLegalCaseStage({
    required int legalCaseId,
    required int stageId,
  });
}

class LegalCasesRemoteDataSourceImpl implements LegalCasesRemoteDataSource {
  final Dio dio;

  LegalCasesRemoteDataSourceImpl({required this.dio});

  @override
  Future<LegalCaseFormDataModel> getLegalCaseFormData() async {
    try {
      final response = await dio.get('owner/legal-cases/form-data');

      if (response.data != null && response.data['data'] != null) {
        return LegalCaseFormDataModel.fromJson(response.data['data']);
      } else {
        throw const ServerException('Invalid response data');
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<LegalCasesListResponseModel> getLegalCasesList({
    LegalCasesFilterParams params = const LegalCasesFilterParams(),
  }) async {
    try {
      final response = await dio.get(
        'owner/legal-cases',
        queryParameters: params.toQueryMap(),
      );

      if (response.data != null && response.data['data'] != null) {
        return LegalCasesListResponseModel.fromJson(response.data['data']);
      } else {
        throw const ServerException('Invalid response data');
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<LegalCaseItemModel> getLegalCaseDetails(int id) async {
    try {
      final response = await dio.get('owner/legal-cases/$id');

      if (response.data != null && response.data['data'] != null) {
        return LegalCaseItemModel.fromJson(response.data['data']);
      } else {
        throw const ServerException('Invalid response data');
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<LegalCaseItemModel> createLegalCase(
    CreateLegalCaseParams params,
  ) async {
    try {
      final response = await dio.post(
        'owner/legal-cases',
        data: FormData.fromMap(params.toJson()),
      );

      if (response.data != null &&
          response.data['data'] != null &&
          response.data['data']['legal_case'] != null) {
        return LegalCaseItemModel.fromJson(response.data['data']['legal_case']);
      } else {
        throw const ServerException('Invalid response data');
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<LegalCaseItemModel> updateLegalCase(
    UpdateLegalCaseParams params,
  ) async {
    try {
      final response = await dio.patch(
        'owner/legal-cases/${params.id}',
        data: params.toJson(),
      );

      if (response.data != null &&
          response.data['data'] != null &&
          response.data['data']['legal_case'] != null) {
        return LegalCaseItemModel.fromJson(response.data['data']['legal_case']);
      } else {
        throw const ServerException('Invalid response data');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        if (e.response!.data['errors'] != null) {
          final errorsMap = Map<String, List<dynamic>>.from(
            e.response!.data['errors'],
          );
          final errorMessage = errorsMap.values
              .map((v) => v.join('\n'))
              .join('\n');
          throw ServerException(
            errorMessage.isNotEmpty ? errorMessage : 'Validation error',
          );
        } else if (e.response!.data['message'] != null) {
          throw ServerException(e.response!.data['message']);
        }
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteLegalCase(int id) async {
    try {
      final response = await dio.delete('owner/legal-cases/$id');

      if (response.data != null && response.data['success'] == true) {
        return;
      } else {
        throw ServerException(
          response.data?['message'] ?? 'Failed to delete legal case',
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw ServerException(
          e.response!.data['message'] ?? 'Failed to delete legal case',
        );
      }
      rethrow;
    }
  }

  @override
  Future<LegalCaseItemModel> addLegalCaseStage(AddStageParams params) async {
    try {
      final response = await dio.post(
        'owner/legal-cases/${params.legalCaseId}/stages',
        data: params.toJson(),
      );

      if (response.data != null &&
          response.data['data'] != null &&
          response.data['data']['legal_case'] != null) {
        return LegalCaseItemModel.fromJson(response.data['data']['legal_case']);
      } else {
        throw const ServerException('Invalid response data');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw ServerException(
          e.response!.data['message'] ?? 'Failed to add stage',
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteLegalCaseStage({
    required int legalCaseId,
    required int stageId,
  }) async {
    try {
      final response = await dio.delete(
        'owner/legal-cases/$legalCaseId/stages/$stageId',
      );

      if (response.data != null && response.data['success'] == true) {
        return;
      } else {
        throw ServerException(
          response.data?['message'] ?? 'Failed to delete stage',
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw ServerException(
          e.response!.data['message'] ?? 'Failed to delete stage',
        );
      }
      rethrow;
    }
  }
}
