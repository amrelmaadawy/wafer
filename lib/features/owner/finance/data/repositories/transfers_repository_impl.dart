import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/create_transfer_request_entity.dart';
import '../../domain/entities/transfer_entity.dart';
import '../../domain/repositories/transfers_repository.dart';
import '../datasources/transfers_remote_data_source.dart';

class TransfersRepositoryImpl implements TransfersRepository {
  final TransfersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TransfersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TransferEntity>>> getTransfers({required int page}) async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getTransfers(page: page);
        return Right(models);
      } on DioException catch (e) {
        return Left(ServerFailure.fromDioException(e));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure(LocaleKeys.errors_no_internet_title.tr()));
    }
  }

  @override
  Future<Either<Failure, TransferEntity>> createTransfer(CreateTransferRequestEntity request) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.createTransfer(request);
        return Right(model);
      } on DioException catch (e) {
        return Left(ServerFailure.fromDioException(e));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure(LocaleKeys.errors_no_internet_title.tr()));
    }
  }
}
