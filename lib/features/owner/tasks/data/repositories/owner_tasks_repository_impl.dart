import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/task_form_data_entity.dart';
import '../../domain/repositories/owner_tasks_repository.dart';
import '../datasources/owner_tasks_remote_data_source.dart';

class OwnerTasksRepositoryImpl implements OwnerTasksRepository {
  final OwnerTasksRemoteDataSource remoteDataSource;

  OwnerTasksRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TaskFormDataEntity>> getTaskFormData() async {
    try {
      final response = await remoteDataSource.getTaskFormData();
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
