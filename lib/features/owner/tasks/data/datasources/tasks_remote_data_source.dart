import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../models/task_form_data_model.dart';
import '../models/task_model.dart';
import '../../domain/entities/create_task_params.dart';
import '../../domain/entities/update_task_params.dart';

abstract class TasksRemoteDataSource {
  Future<TaskFormDataModel> getTaskFormData();
  Future<(List<TaskModel>, TasksPaginationMetaModel)> getTasks({
    required int page,
    int perPage = 15,
  });

  Future<TaskModel> getTaskDetails(int id);
  Future<TaskModel> createTask(CreateTaskParams params);
  Future<TaskModel> updateTask(UpdateTaskParams params);
  Future<void> deleteTask(int id);
}

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final Dio dio;

  TasksRemoteDataSourceImpl({required this.dio});

  @override
  Future<TaskFormDataModel> getTaskFormData() async {
    final response = await dio.get(ApiConstants.ownerTasksFormData);
    return TaskFormDataModel.fromJson(response.data['data']);
  }

  @override
  Future<(List<TaskModel>, TasksPaginationMetaModel)> getTasks({
    required int page,
    int perPage = 15,
  }) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}owner/tasks',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        final List<dynamic> tasksJson = data['tasks'] ?? [];
        final tasks = tasksJson.map((e) => TaskModel.fromJson(e)).toList();
        final pagination = TasksPaginationMetaModel.fromJson(data['pagination'] ?? {});
        return (tasks, pagination);
      } else {
        throw ServerException(response.data['message']);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TaskModel> getTaskDetails(int id) async {
    try {
      final response = await dio.get('${ApiConstants.baseUrl}owner/tasks/$id');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        return TaskModel.fromJson(data);
      } else {
        throw ServerException(response.data['message']);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TaskModel> createTask(CreateTaskParams params) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}owner/tasks',
        data: params.toJson(),
      );

      if (response.data['success'] == true) {
        return TaskModel.fromJson(response.data['data']['task']);
      } else {
        throw ServerException(response.data['message']);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TaskModel> updateTask(UpdateTaskParams params) async {
    try {
      final response = await dio.patch(
        '${ApiConstants.baseUrl}owner/tasks/${params.id}',
        data: params.toJson(),
      );

      if (response.data['success'] == true) {
        return TaskModel.fromJson(response.data['data']['task']);
      } else {
        throw ServerException(response.data['message']);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    try {
      final response = await dio.delete('${ApiConstants.baseUrl}owner/tasks/$id');

      if (response.data['success'] != true) {
        throw ServerException(response.data['message']);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
