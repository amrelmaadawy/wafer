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
  Future<TaskModel> updateTaskStatus(int id, String status);
  Future<TaskModel> updateTaskProgress(int id, int progress);
  Future<TaskModel> updateTaskPriority(int id, String priority);
  Future<TaskModel> addTaskComment(int id, String body);
  Future<TaskModel> addTaskAssignee(int id, int userId);
  Future<TaskModel> removeTaskAssignee(int taskId, int assigneeId);
  Future<TaskModel> updateTaskDates(int id, String? startDate, String? dueDate);
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
  Future<TaskModel> updateTaskStatus(int id, String status) async {
    try {
      final response = await dio.patch(
        '${ApiConstants.baseUrl}owner/tasks/$id/status',
        data: {'status': status},
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

  @override
  Future<TaskModel> updateTaskProgress(int id, int progress) async {
    try {
      final response = await dio.patch(
        '${ApiConstants.baseUrl}owner/tasks/$id/progress',
        data: {'progress': progress},
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
  Future<TaskModel> updateTaskPriority(int id, String priority) async {
    try {
      final response = await dio.patch(
        '${ApiConstants.baseUrl}owner/tasks/$id/priority',
        data: {'priority': priority},
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
  Future<TaskModel> updateTaskDates(int id, String? startDate, String? dueDate) async {
    try {
      final data = <String, dynamic>{};
      if (startDate != null) data['start_date'] = startDate;
      if (dueDate != null) data['due_date'] = dueDate;

      final response = await dio.patch(
        '${ApiConstants.baseUrl}owner/tasks/$id/date',
        data: data,
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
  Future<TaskModel> addTaskComment(int id, String body) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}owner/tasks/$id/comments',
        data: {
          'body': body,
        },
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
  Future<TaskModel> addTaskAssignee(int id, int userId) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}owner/tasks/$id/assignees',
        data: {
          'user_id': userId,
        },
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
  Future<TaskModel> removeTaskAssignee(int taskId, int assigneeId) async {
    try {
      final response = await dio.delete(
        '${ApiConstants.baseUrl}owner/tasks/$taskId/assignees/$assigneeId',
      );

      if (response.data['success'] == true) {
        if (response.data['data'] != null && response.data['data']['task'] != null) {
          return TaskModel.fromJson(response.data['data']['task']);
        }
        // Fallback: If task is not returned, we might just throw or return something,
        // but since we return TaskModel, let's assume it returns task or throw error
        // Or we can return an empty model and rely on fetch.
        // Actually, if it's not returned, we will fail here, which is fine since the user said it returns the task.
        throw ServerException('Task data not found in response');
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to remove assignee');
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
