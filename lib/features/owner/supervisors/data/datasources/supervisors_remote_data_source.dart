import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_constants.dart';
import '../../domain/entities/create_maintenance_supervisor_params.dart';
import '../models/supervisor_form_data_response_model.dart';
import '../models/supervisors_list_response_model.dart';
import '../models/supervisor_model.dart';

abstract class SupervisorsRemoteDataSource {
  Future<SupervisorFormDataResponseModel> getFormData();
  Future<SupervisorsListResponseModel> getSupervisors(int page);
  Future<SupervisorModel> createSupervisor(CreateMaintenanceSupervisorParams params);
}

class SupervisorsRemoteDataSourceImpl implements SupervisorsRemoteDataSource {
  final Dio client;

  SupervisorsRemoteDataSourceImpl(this.client);

  @override
  Future<SupervisorFormDataResponseModel> getFormData() async {
    try {
      final response = await client.get(
        ApiConstants.ownerMaintenanceSupervisorsFormData,
      );

      return SupervisorFormDataResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server Error');
    } catch (e) {
      throw const ServerException('Failed to parse form data');
    }
  }

  @override
  Future<SupervisorsListResponseModel> getSupervisors(int page) async {
    try {
      final response = await client.get(
        ApiConstants.ownerMaintenanceSupervisors,
        queryParameters: {'page': page},
      );

      return SupervisorsListResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server Error');
    } catch (e) {
      throw const ServerException('Failed to parse supervisors list');
    }
  }

  @override
  Future<SupervisorModel> createSupervisor(CreateMaintenanceSupervisorParams params) async {
    try {
      final response = await client.post(
        ApiConstants.ownerMaintenanceSupervisors,
        data: params.toJson(),
      );

      return SupervisorModel.fromJson(
        response.data['data']['maintenance_supervisor'],
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server Error');
    } catch (e) {
      throw const ServerException('Failed to parse response');
    }
  }
}
