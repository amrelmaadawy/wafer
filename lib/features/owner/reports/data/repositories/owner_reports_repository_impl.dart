import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../domain/entities/defaulter_entity.dart';
import '../../domain/entities/occupancy_property_entity.dart';
import '../../domain/entities/revenue_entry_entity.dart';
import '../../domain/repositories/owner_reports_repository.dart';
import '../datasources/owner_reports_remote_data_source.dart';

class OwnerReportsRepositoryImpl implements OwnerReportsRepository {
  final OwnerReportsRemoteDataSource _remoteDataSource;

  OwnerReportsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<RevenueEntryEntity>>> getRevenueReport({
    bool forceRefresh = false,
  }) async {
    try {
      final result = await _remoteDataSource.getRevenueReport();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      String? serverMsg;
      if (e.response?.data is Map<String, dynamic>) {
        serverMsg =
            (e.response?.data as Map<String, dynamic>)['message'] as String?;
      }
      return Left(ServerFailure(
          serverMsg ?? e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OccupancyPropertyEntity>>> getOccupancyReport({
    bool forceRefresh = false,
  }) async {
    try {
      final result = await _remoteDataSource.getOccupancyReport();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      String? serverMsg;
      if (e.response?.data is Map<String, dynamic>) {
        serverMsg =
            (e.response?.data as Map<String, dynamic>)['message'] as String?;
      }
      return Left(ServerFailure(
          serverMsg ?? e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DefaulterEntity>>> getDefaultersReport({
    bool forceRefresh = false,
  }) async {
    try {
      final result = await _remoteDataSource.getDefaultersReport();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      String? serverMsg;
      if (e.response?.data is Map<String, dynamic>) {
        serverMsg =
            (e.response?.data as Map<String, dynamic>)['message'] as String?;
      }
      return Left(ServerFailure(
          serverMsg ?? e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
