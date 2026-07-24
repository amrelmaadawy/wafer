import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../domain/entities/properties_pagination_meta_entity.dart';
import '../../domain/entities/properties_query_filter_entity.dart';
import '../../domain/entities/properties_stats_entity.dart';
import '../../domain/entities/property_details_entity.dart';
import '../../domain/entities/property_form_data_entity.dart';
import '../../domain/entities/property_list_item_entity.dart';
import '../../domain/repositories/properties_repository.dart';
import '../datasources/properties_remote_data_source.dart';

class PropertiesRepositoryImpl implements PropertiesRepository {
  final PropertiesRemoteDataSource remoteDataSource;

  PropertiesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<
      Either<
          Failure,
          ({
            List<PropertyListItemEntity> items,
            PropertiesPaginationMetaEntity meta,
            PropertiesStatsEntity stats,
          })>> getProperties({
    int page = 1,
    PropertiesQueryFilterEntity? filter,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
      };

      if (filter != null) {
        if (filter.search != null) queryParams['search'] = filter.search;
        if (filter.status != null) queryParams['status'] = filter.status;
        if (filter.propertyType != null) queryParams['property_type'] = filter.propertyType;
        if (filter.usageType != null) queryParams['usage_type'] = filter.usageType;
        if (filter.branchId != null) queryParams['branch_id'] = filter.branchId;
        if (filter.deedId != null) queryParams['deed_id'] = filter.deedId;
        queryParams['per_page'] = filter.perPage;
        queryParams['include_tree'] = filter.includeTree;
      }

      final result = await remoteDataSource.getProperties(queryParams);
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
  Future<Either<Failure, PropertyFormOptionsEntity>> getFormOptions() async {
    try {
      final result = await remoteDataSource.getFormOptions();
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
  Future<Either<Failure, PropertyFormDataEntity>> getPropertyFormData() async {
    try {
      final result = await remoteDataSource.getPropertyFormData();
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
  Future<Either<Failure, PropertyDetailsEntity>> getPropertyDetails(int propertyId) async {
    try {
      final result = await remoteDataSource.getPropertyDetails(propertyId);
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
  Future<Either<Failure, int>> createDraftProperty(Map<String, dynamic> body) async {
    try {
      final result = await remoteDataSource.createDraftProperty(body);
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
  Future<Either<Failure, void>> autoSavePropertyStep({
    required int propertyId,
    required String step,
    required Map<String, dynamic> data,
  }) async {
    try {
      await remoteDataSource.autoSavePropertyStep(
        propertyId: propertyId,
        step: step,
        data: data,
      );
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
  Future<Either<Failure, PropertyDetailsEntity>> autoSaveDeedStep(
      int propertyId, int deedId, int branchId) async {
    try {
      final result = await remoteDataSource.autoSaveDeedStep(
          propertyId, deedId, branchId);
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
  Future<Either<Failure, PropertyDetailsEntity>> autoSaveTypeStep(
      int propertyId, String propertyType) async {
    try {
      final result = await remoteDataSource.autoSaveTypeStep(
          propertyId, propertyType);
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
  Future<Either<Failure, void>> syncOwners(
      int propertyId, List<Map<String, dynamic>> owners) async {
    try {
      await remoteDataSource.syncOwners(propertyId, owners);
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
  Future<Either<Failure, String>> uploadTempFile(String filePath) async {
    try {
      final result = await remoteDataSource.uploadTempFile(filePath);
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
  Future<Either<Failure, void>> addUploadedImagePath(
      int propertyId, String imagePath) async {
    try {
      await remoteDataSource.addUploadedImagePath(propertyId, imagePath);
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
  Future<Either<Failure, void>> publishProperty(int propertyId) async {
    try {
      await remoteDataSource.publishProperty(propertyId);
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
  Future<Either<Failure, int>> cloneProperty(int propertyId) async {
    try {
      final result = await remoteDataSource.cloneProperty(propertyId);
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
  Future<Either<Failure, void>> makeRepresentative(
      int propertyId, Map<String, dynamic> body) async {
    try {
      await remoteDataSource.makeRepresentative(propertyId, body);
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
  Future<Either<Failure, void>> removeRepresentative(int propertyId) async {
    try {
      await remoteDataSource.removeRepresentative(propertyId);
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
  Future<Either<Failure, void>> deleteProperty(int propertyId) async {
    try {
      await remoteDataSource.deleteProperty(propertyId);
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
  Future<Either<Failure, void>> patchProperty(
      int propertyId, Map<String, dynamic> data) async {
    try {
      await remoteDataSource.patchProperty(propertyId, data);
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
