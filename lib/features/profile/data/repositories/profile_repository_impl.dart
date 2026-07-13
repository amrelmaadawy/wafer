import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/storage/cache_helper.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final CacheHelper _cacheHelper;

  ProfileRepositoryImpl(this._remoteDataSource, this._cacheHelper);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cachedJson = _cacheHelper.getCachedProfile();
      if (cachedJson != null && cachedJson.isNotEmpty) {
        try {
          final data = jsonDecode(cachedJson) as Map<String, dynamic>;
          return Right(ProfileModel.fromJson(data));
        } catch (_) {
          // Ignore cache error and fetch from remote
        }
      }
    }

    try {
      final result = await _remoteDataSource.getProfile();
      try {
        await _cacheHelper.saveCachedProfile(jsonEncode(result.toJson()));
      } catch (_) {
        // Cache saving non-fatal
      }
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      final cachedJson = _cacheHelper.getCachedProfile();
      if (cachedJson != null && cachedJson.isNotEmpty) {
        try {
          final data = jsonDecode(cachedJson) as Map<String, dynamic>;
          return Right(ProfileModel.fromJson(data));
        } catch (_) {}
      }
      return Left(ServerFailure(e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String name,
    required String phone,
    required String gender,
  }) async {
    try {
      final result = await _remoteDataSource.updateProfile(
        name: name,
        phone: phone,
        gender: gender,
      );
      try {
        await _cacheHelper.saveCachedProfile(jsonEncode(result.toJson()));
      } catch (_) {
        // Cache saving non-fatal
      }
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

