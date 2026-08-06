import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../models/supervisor_form_data_response_model.dart';
import '../models/supervisors_list_response_model.dart';
import '../models/supervisor_model.dart';

abstract class SupervisorsRemoteDataSource {
  Future<SupervisorFormDataResponseModel> getFormData();
  Future<SupervisorsListResponseModel> getSupervisors(int page);
  Future<SupervisorModel> createSupervisor(Map<String, dynamic> body);
}

class SupervisorsRemoteDataSourceImpl implements SupervisorsRemoteDataSource {
  final Dio client;

  SupervisorsRemoteDataSourceImpl(this.client);

  @override
  Future<SupervisorFormDataResponseModel> getFormData() async {
    try {
      final response = await client.get(
        'owner/maintenance-supervisors/form-data',
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
        'owner/maintenance-supervisors',
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
  Future<SupervisorModel> createSupervisor(Map<String, dynamic> body) async {
    try {
      final response = await client.post(
        'owner/maintenance-supervisors',
        data: body,
      );

      return SupervisorModel.fromJson(
        response.data['data']['maintenance_supervisor'],
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server Error');
    } catch (e, stack) {
      throw ServerException('Parse error: $e\n$stack');
    }
  }
}
