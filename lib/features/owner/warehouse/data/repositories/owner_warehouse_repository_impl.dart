import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/warehouse_items_response_entity.dart';
import '../../domain/entities/warehouse_summary_entity.dart';
import '../../domain/entities/warehouse_item_entity.dart';
import '../../domain/entities/warehouse_item_details_entity.dart';
import '../../domain/entities/create_warehouse_item_params.dart';
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

  @override
  Future<Either<Failure, WarehouseItemsResponseEntity>> getWarehouseItems({
    int page = 1,
    String? search,
    String? category,
    int? warehouseId,
    String? status,
  }) async {
    try {
      final response = await remoteDataSource.getWarehouseItems(
        page: page,
        search: search,
        category: category,
        warehouseId: warehouseId,
        status: status,
      );
      return Right(response);
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

  @override
  Future<Either<Failure, WarehouseItemEntity>> createWarehouseItem(
    CreateWarehouseItemParams params,
  ) async {
    try {
      final item = await remoteDataSource.createWarehouseItem(params);
      return Right(item);
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
  @override
  Future<Either<Failure, WarehouseItemDetailsEntity>> getWarehouseItemDetails(
    int id,
  ) async {
    try {
      final details = await remoteDataSource.getWarehouseItemDetails(id);
      return Right(details);
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
