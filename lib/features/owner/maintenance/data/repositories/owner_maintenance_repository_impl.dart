import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../../domain/entities/maintenance_response_entity.dart';
import '../../domain/repositories/owner_maintenance_repository.dart';
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
  Future<Either<Failure, MaintenanceItemEntity>> getMaintenanceDetails(
      int id) async {
    try {
      final result = await _remoteDataSource.getMaintenanceDetails(id);
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
