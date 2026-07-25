import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/entities/unit_full_details_entity.dart';
import '../../domain/entities/properties_pagination_meta_entity.dart';
import '../../domain/entities/unit_create_entity.dart';
import '../../domain/repositories/units_repository.dart';
import '../models/unit_create_model.dart';
import '../datasources/units_remote_data_source.dart';

class UnitsRepositoryImpl implements UnitsRepository {
  final UnitsRemoteDataSource _remoteDataSource;

  UnitsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ({List<UnitEntity> items, PropertiesPaginationMetaEntity meta})>> getPropertyUnits(
    int propertyId, {
    int page = 1,
    String? search,
    String? unitStatus,
    String? unitType,
  }) async {
    try {
      final result = await _remoteDataSource.getPropertyUnits(
        propertyId,
        page: page,
        search: search,
        unitStatus: unitStatus,
        unitType: unitType,
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
  Future<Either<Failure, int>> createDraftUnit(int propertyId) async {
    try {
      final result = await _remoteDataSource.createDraftUnit(propertyId);
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
  Future<Either<Failure, void>> autoSaveUnit(int propertyId, int unitId, Map<String, dynamic> data) async {
    try {
      await _remoteDataSource.autoSaveUnit(propertyId, unitId, data);
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
  Future<Either<Failure, UnitFullDetailsEntity>> getUnitDetails(int propertyId, int unitId) async {
    try {
      final result = await _remoteDataSource.getUnitDetails(propertyId, unitId);
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
  Future<Either<Failure, void>> publishUnit(int propertyId, int unitId) async {
    try {
      await _remoteDataSource.publishUnit(propertyId, unitId);
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
  Future<Either<Failure, int>> createUnitDirect(int propertyId, UnitCreateEntity unit) async {
    try {
      final model = UnitCreateModel.fromEntity(unit);
      final result = await _remoteDataSource.createUnitDirect(propertyId, model);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
