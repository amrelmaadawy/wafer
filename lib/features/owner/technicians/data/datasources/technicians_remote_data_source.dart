import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/technician_form_data_model.dart';
import '../models/technicians_list_response_model.dart';
import '../models/technician_model.dart';
import '../../domain/usecases/add_technician_use_case.dart';

abstract class TechniciansRemoteDataSource {
  Future<TechnicianFormDataModel> getTechnicianFormData();
  Future<TechniciansListResponseModel> getTechniciansList({
    required int page,
    Map<String, dynamic>? filters,
  });
  Future<TechnicianModel> addTechnician(AddTechnicianParams params);
}

class TechniciansRemoteDataSourceImpl implements TechniciansRemoteDataSource {
  final Dio _dio;

  TechniciansRemoteDataSourceImpl(this._dio);

  @override
  Future<TechnicianFormDataModel> getTechnicianFormData() async {
    final response = await _dio.get(
      ApiConstants.ownerMaintenanceTechniciansFormData,
    );

    final data = response.data['data'] as Map<String, dynamic>? ??
        response.data as Map<String, dynamic>;
    return TechnicianFormDataModel.fromJson(data);
  }

  @override
  Future<TechniciansListResponseModel> getTechniciansList({
    required int page,
    Map<String, dynamic>? filters,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      ...?filters,
    };

    final response = await _dio.get(
      ApiConstants.ownerMaintenanceTechnicians,
      queryParameters: queryParams,
    );

    final data = response.data['data'] as Map<String, dynamic>? ??
        response.data as Map<String, dynamic>;
    return TechniciansListResponseModel.fromJson(data);
  }

  @override
  Future<TechnicianModel> addTechnician(AddTechnicianParams params) async {
    final response = await _dio.post(
      ApiConstants.ownerMaintenanceTechnicians,
      data: params.toJson(),
    );

    final data = response.data['data']?['maintenance_technician'] as Map<String, dynamic>? ??
        response.data as Map<String, dynamic>;
    return TechnicianModel.fromJson(data);
  }
}
