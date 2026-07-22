import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/repositories/units_repository.dart';
import '../datasources/units_remote_data_source.dart';

class UnitsRepositoryImpl implements UnitsRepository {
  final UnitsRemoteDataSource _remoteDataSource;

  UnitsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<UnitEntity>>> getPropertyUnits(int propertyId) async {
    try {
      final result = await _remoteDataSource.getPropertyUnits(propertyId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> createDraftUnit(int propertyId) async {
    try {
      final result = await _remoteDataSource.createDraftUnit(propertyId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> autoSaveUnit(int propertyId, int unitId, Map<String, dynamic> data) async {
    try {
      await _remoteDataSource.autoSaveUnit(propertyId, unitId, data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UnitEntity>> getUnitDetails(int propertyId, int unitId) async {
    try {
      final result = await _remoteDataSource.getUnitDetails(propertyId, unitId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> publishUnit(int propertyId, int unitId) async {
    try {
      await _remoteDataSource.publishUnit(propertyId, unitId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
