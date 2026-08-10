import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/owner_dashboard_entity.dart';
import '../../domain/repositories/owner_dashboard_repository.dart';
import '../datasources/owner_dashboard_remote_data_source.dart';

class OwnerDashboardRepositoryImpl implements OwnerDashboardRepository {
  final OwnerDashboardRemoteDataSource _remoteDataSource;

  OwnerDashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, OwnerDashboardEntity>> getDashboardStats({
    bool forceRefresh = false,
  }) async {
    try {
      final result = await _remoteDataSource.getDashboardStats(forceRefresh: forceRefresh);
      return Right(result);
    } on TypeError catch (_) {
      // If cache deserialization fails due to schema change, retry from network
      if (!forceRefresh) {
        return getDashboardStats(forceRefresh: true);
      }
      return const Left(ServerFailure("Data format error"));
    } on FormatException catch (_) {
      if (!forceRefresh) {
        return getDashboardStats(forceRefresh: true);
      }
      return const Left(ServerFailure("Data format error"));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
