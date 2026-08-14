import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/error/exceptions.dart';
import '../../domain/entities/supervisor_entity.dart';
import '../../domain/entities/supervisor_form_data_entity.dart';
import '../../domain/entities/supervisors_list_response_entity.dart';
import '../../domain/entities/create_maintenance_supervisor_params.dart';
import '../../domain/repositories/supervisors_repository.dart';
import '../datasources/supervisors_remote_data_source.dart';

class SupervisorsRepositoryImpl implements SupervisorsRepository {
  final SupervisorsRemoteDataSource remoteDataSource;

  SupervisorsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, SupervisorFormDataEntity>> getFormData() async {
    try {
      final response = await remoteDataSource.getFormData();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, SupervisorsListResponseEntity>> getSupervisors(
    int page,
  ) async {
    try {
      final response = await remoteDataSource.getSupervisors(page);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, SupervisorEntity>> createSupervisor(
    CreateMaintenanceSupervisorParams params,
  ) async {
    try {
      final response = await remoteDataSource.createSupervisor(params);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
