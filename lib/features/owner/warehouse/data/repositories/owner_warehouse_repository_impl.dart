import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/warehouse_summary_entity.dart';
import '../../domain/repositories/owner_warehouse_repository.dart';
import '../datasources/owner_warehouse_remote_data_source.dart';

class OwnerWarehouseRepositoryImpl implements OwnerWarehouseRepository {
  final OwnerWarehouseRemoteDataSource remoteDataSource;

  OwnerWarehouseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WarehouseSummaryEntity>> getWarehouseSummary() async {
    try {
      final summary = await remoteDataSource.getWarehouseSummary();
      return Right(summary);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.response?.data['message'] ?? e.message ?? 'Unknown Error',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
