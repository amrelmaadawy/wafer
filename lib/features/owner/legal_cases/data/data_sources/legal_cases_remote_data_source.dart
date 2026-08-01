import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/legal_case_form_data_model.dart';
import '../models/legal_cases_list_response_model.dart';

abstract class LegalCasesRemoteDataSource {
  Future<LegalCaseFormDataModel> getLegalCaseFormData();
  Future<LegalCasesListResponseModel> getLegalCasesList({
    int page = 1,
    int perPage = 15,
    String? status,
  });
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
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          e.response?.data['message'] ?? 'حدث خطأ في الخادم',
        );
      } else {
        throw const ServerException('فشل الاتصال بالخادم');
      }
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
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          e.response?.data['message'] ?? 'حدث خطأ في الخادم',
        );
      } else {
        throw const ServerException('فشل الاتصال بالخادم');
      }
    }
  }
}
