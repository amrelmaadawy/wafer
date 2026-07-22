import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../domain/entities/deed_entity.dart';
import '../../domain/repositories/deeds_repository.dart';
import '../datasources/deeds_remote_data_source.dart';

class DeedsRepositoryImpl implements DeedsRepository {
  final DeedsRemoteDataSource _remoteDataSource;

  DeedsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<DeedEntity>>> getOwnerDeeds() async {
    try {
      final result = await _remoteDataSource.getOwnerDeeds();
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
  Future<Either<Failure, DeedEntity>> createDeed(Map<String, dynamic> body) async {
    try {
      final result = await _remoteDataSource.createDeed(body);
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
