import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../domain/entities/notifications_response_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;

  NotificationsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, NotificationsResponseEntity>> getNotifications({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    try {
      final result = await _remoteDataSource.getNotifications(page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      String? serverMsg;
      if (e.response?.data is Map<String, dynamic>) {
        serverMsg = (e.response?.data as Map<String, dynamic>)['message'] as String?;
      }
      return Left(ServerFailure(serverMsg ?? e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadNotificationsCount() async {
    try {
      final result = await _remoteDataSource.getUnreadNotificationsCount();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      String? serverMsg;
      if (e.response?.data is Map<String, dynamic>) {
        serverMsg = (e.response?.data as Map<String, dynamic>)['message'] as String?;
      }
      return Left(ServerFailure(serverMsg ?? e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
