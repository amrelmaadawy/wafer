import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/legal_case_form_data_model.dart';
import '../models/legal_cases_list_response_model.dart';
import '../models/legal_case_item_model.dart';
import '../../domain/usecases/create_legal_case_use_case.dart';

abstract class LegalCasesRemoteDataSource {
  Future<LegalCaseFormDataModel> getLegalCaseFormData();
  Future<LegalCasesListResponseModel> getLegalCasesList({
    int page = 1,
    int perPage = 15,
    String? status,
  });
  Future<LegalCaseItemModel> getLegalCaseDetails(int id);
  Future<LegalCaseItemModel> createLegalCase(CreateLegalCaseParams params);
}

class LegalCasesRemoteDataSourceImpl implements LegalCasesRemoteDataSource {
  final Dio dio;

  LegalCasesRemoteDataSourceImpl({required this.dio});

  @override
  Future<LegalCaseFormDataModel> getLegalCaseFormData() async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}owner/legal-cases/form-data',
      );
      
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
    int page = 1,
    int perPage = 15,
    String? status,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'per_page': perPage,
      };

      if (status != null && status.isNotEmpty && status != 'الكل') {
        queryParameters['status'] = status;
      }

      final response = await dio.get(
        '${ApiConstants.baseUrl}owner/legal-cases',
        queryParameters: queryParameters,
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
      final response = await dio.get(
        '${ApiConstants.baseUrl}owner/legal-cases/$id',
      );

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
  Future<LegalCaseItemModel> createLegalCase(CreateLegalCaseParams params) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}owner/legal-cases',
        data: FormData.fromMap(params.toJson()),
      );

      if (response.data != null && response.data['data'] != null && response.data['data']['legal_case'] != null) {
        return LegalCaseItemModel.fromJson(response.data['data']['legal_case']);
      } else {
        throw const ServerException('Invalid response data');
      }
    } on DioException {
      rethrow;
    }
  }
}
