import 'package:dio/dio.dart';
import '../models/negotiation_form_data_response_model.dart';
import '../models/negotiations_list_response_model.dart';

abstract class MaintenanceNegotiationRemoteDataSource {
  Future<NegotiationFormDataModel> getFormData();
  Future<NegotiationsListResponseModel> getNegotiationsList({
    required int page,
    required int perPage,
  });
  Future<NegotiationModel> createNegotiation({
    required num approvalLimit,
    required bool isActive,
  });
}

class MaintenanceNegotiationRemoteDataSourceImpl
    implements MaintenanceNegotiationRemoteDataSource {
  final Dio dio;

  MaintenanceNegotiationRemoteDataSourceImpl({required this.dio});

  @override
  Future<NegotiationFormDataModel> getFormData() async {
    final response = await dio.get('owner/maintenance-negotiations/form-data');
    final responseModel = NegotiationFormDataResponseModel.fromJson(
      response.data,
    );

    if (!responseModel.success) {
      throw Exception(responseModel.message);
    }

    return responseModel.data;
  }

  @override
  Future<NegotiationsListResponseModel> getNegotiationsList({
    required int page,
    required int perPage,
  }) async {
    final response = await dio.get(
      'owner/maintenance-negotiations',
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final dataMap = response.data as Map<String, dynamic>;
    final responseModel = NegotiationsListResponseModel.fromJson(dataMap);

    if (dataMap['success'] == false) {
      throw Exception(dataMap['message'] ?? 'Failed to load list');
    }

    return responseModel;
  }

  @override
  Future<NegotiationModel> createNegotiation({
    required num approvalLimit,
    required bool isActive,
  }) async {
    final response = await dio.post(
      'owner/maintenance-negotiations',
      data: {'approval_limit': approvalLimit, 'is_active': isActive},
    );

    final dataMap = response.data as Map<String, dynamic>;
    if (dataMap['success'] == false) {
      throw Exception(dataMap['message'] ?? 'Failed to create negotiation');
    }

    final data = dataMap['data'] as Map<String, dynamic>;
    final negotiationMap =
        data['maintenance_negotiation'] as Map<String, dynamic>;
    return NegotiationModel.fromJson(negotiationMap);
  }
}
