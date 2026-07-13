import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/owner_dashboard_entity.dart';
import '../../domain/repositories/owner_repository.dart';
import '../datasources/owner_remote_data_source.dart';

class OwnerRepositoryImpl implements OwnerRepository {
  final OwnerRemoteDataSource _remoteDataSource;

  OwnerRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, OwnerDashboardEntity>> getDashboardStats({bool forceRefresh = false}) async {
    try {
      final result = await _remoteDataSource.getDashboardStats();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'حدث خطأ في الاتصال بالسيرفر'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
