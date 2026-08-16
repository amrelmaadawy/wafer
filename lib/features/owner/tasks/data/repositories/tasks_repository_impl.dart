import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/task_form_data_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/tasks_filter_params.dart';
import '../../domain/entities/tasks_pagination_meta_entity.dart';
import '../../domain/entities/create_task_params.dart';
import '../../domain/entities/update_task_params.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_remote_data_source.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;

  TasksRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TaskFormDataEntity>> getTaskFormData() async {
    try {
      final model = await remoteDataSource.getTaskFormData();
      return Right(model);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, (List<TaskEntity>, TasksPaginationMetaEntity)>> getTasks({
    TasksFilterParams params = const TasksFilterParams(),
  }) async {
    try {
      final result = await remoteDataSource.getTasks(params: params);
      return Right((
        result.$1.cast<TaskEntity>(),
        result.$2 as TasksPaginationMetaEntity,
      ));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskDetails({required int id}) async {
    try {
      final task = await remoteDataSource.getTaskDetails(id);
      return Right(task);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(CreateTaskParams params) async {
    try {
      final task = await remoteDataSource.createTask(params);
      return Right(task);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(UpdateTaskParams params) async {
    try {
      final task = await remoteDataSource.updateTask(params);
      return Right(task);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTaskStatus(int id, String status) async {
    try {
      final task = await remoteDataSource.updateTaskStatus(id, status);
      return Right(task);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTaskProgress(int id, int progress) async {
    try {
      final task = await remoteDataSource.updateTaskProgress(id, progress);
      return Right(task);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTaskPriority(int id, String priority) async {
    try {
      final task = await remoteDataSource.updateTaskPriority(id, priority);
      return Right(task);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> addTaskComment(int id, String body) async {
    try {
      final task = await remoteDataSource.addTaskComment(id, body);
      return Right(task);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> addTaskAssignee(int id, int userId) async {
    try {
      final task = await remoteDataSource.addTaskAssignee(id, userId);
      return Right(task);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> removeTaskAssignee(int taskId, int assigneeId) async {
    try {
      final task = await remoteDataSource.removeTaskAssignee(taskId, assigneeId);
      return Right(task);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTaskDates(int id, String? startDate, String? dueDate) async {
    try {
      final task = await remoteDataSource.updateTaskDates(id, startDate, dueDate);
      return Right(task);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(int id) async {
    try {
      await remoteDataSource.deleteTask(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
