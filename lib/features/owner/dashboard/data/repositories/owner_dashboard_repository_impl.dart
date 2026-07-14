import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../domain/entities/owner_dashboard_entity.dart';
import '../../domain/repositories/owner_dashboard_repository.dart';
import '../datasources/owner_dashboard_remote_data_source.dart';

class OwnerDashboardRepositoryImpl implements OwnerDashboardRepository {
  final OwnerDashboardRemoteDataSource _remoteDataSource;

  OwnerDashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, OwnerDashboardEntity>> getDashboardStats({bool forceRefresh = false}) async {
    try {
      final result = await _remoteDataSource.getDashboardStats();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
