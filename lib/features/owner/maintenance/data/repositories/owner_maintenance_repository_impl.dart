import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../../domain/entities/maintenance_response_entity.dart';
import '../../domain/repositories/owner_maintenance_repository.dart';
import '../../domain/usecases/create_owner_maintenance_use_case.dart';
import '../../domain/usecases/update_owner_maintenance_use_case.dart';
import '../datasources/owner_maintenance_remote_data_source.dart';

class OwnerMaintenanceRepositoryImpl implements OwnerMaintenanceRepository {
  final OwnerMaintenanceRemoteDataSource _remoteDataSource;

  OwnerMaintenanceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, MaintenanceResponseEntity>> getMaintenanceRequests({
    required int page,
    String? status,
    bool forceRefresh = false,
  }) async {
    try {
      final result = await _remoteDataSource.getMaintenanceRequests(
        page: page,
        status: status,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaintenanceItemEntity>> getMaintenanceDetails(
    int id,
  ) async {
    try {
      final result = await _remoteDataSource.getMaintenanceDetails(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createMaintenanceRequest(
    CreateOwnerMaintenanceParams params,
  ) async {
    try {
      await _remoteDataSource.createMaintenanceRequest(params);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaintenanceItemEntity>> updateMaintenanceRequest(
    UpdateOwnerMaintenanceParams params,
  ) async {
    try {
      final result = await _remoteDataSource.updateMaintenanceRequest(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMaintenanceRequest(int id) async {
    try {
      await _remoteDataSource.deleteMaintenanceRequest(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
