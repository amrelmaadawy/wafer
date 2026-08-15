import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/task_form_data_entity.dart';
import '../../domain/entities/task_entity.dart';
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
    required int page,
    int perPage = 15,
  }) async {
    try {
      final result = await remoteDataSource.getTasks(page: page, perPage: perPage);
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
