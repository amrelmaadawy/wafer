import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/task_form_data_model.dart';

abstract class OwnerTasksRemoteDataSource {
  Future<TaskFormDataModel> getTaskFormData();
}

class OwnerTasksRemoteDataSourceImpl implements OwnerTasksRemoteDataSource {
  final Dio dio;

  OwnerTasksRemoteDataSourceImpl({required this.dio});

  @override
  Future<TaskFormDataModel> getTaskFormData() async {
    final response = await dio.get(ApiConstants.ownerTasksFormData);
    if (response.data['success'] == true && response.data['data'] != null) {
      return TaskFormDataModel.fromJson(response.data['data']);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: response.data['message'] ?? 'Failed to load task form data',
      );
    }
  }
}
