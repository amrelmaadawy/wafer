import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';
import '../localization/locale_keys.dart';
import '../network/connectivity/network_info.dart';

/// Base class for all repository implementations.
///
/// Provides [executeApiCall] which:
///   1. Checks internet connectivity first.
///   2. Catches [DioException], [ServerException], and generic [Exception].
///   3. Maps them to typed [Failure] objects so Domain never sees raw errors.
abstract class BaseRepository {
  final NetworkInfo networkInfo;

  const BaseRepository({required this.networkInfo});

  /// Wraps any async API call with connectivity check + error mapping.
  ///
  /// ```dart
  /// return executeApiCall(
  ///   call: () => remoteDataSource.getProperties(params),
  /// );
  /// ```
  Future<Either<Failure, T>> executeApiCall<T>({
    required Future<T> Function() call,
  }) async {
    // 1. Guard: internet connectivity
    final connected = await networkInfo.isConnected;
    if (!connected) {
      return Left(NetworkFailure(LocaleKeys.errorsNetworkError.tr()));
    }

    // 2. Execute and map errors
    try {
      final result = await call();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
