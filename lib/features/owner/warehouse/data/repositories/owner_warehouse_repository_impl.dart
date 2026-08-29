import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/warehouse_items_response_entity.dart';
import '../../domain/entities/warehouse_summary_entity.dart';
import '../../domain/entities/warehouse_item_entity.dart' hide WarehouseEntity;
import '../../domain/entities/warehouse_entity.dart';
import '../../domain/entities/warehouse_item_details_entity.dart';
import '../../domain/entities/warehouse_item_update_result_entity.dart';
import '../../domain/entities/create_warehouse_item_params.dart';
import '../../domain/entities/create_owner_warehouse_params.dart';
import '../../domain/entities/update_warehouse_item_params.dart';
import '../../domain/entities/update_owner_warehouse_params.dart';
import '../../domain/repositories/owner_warehouse_repository.dart';

import '../datasources/owner_warehouse_remote_data_source.dart';
import '../models/update_warehouse_item_params_model.dart';


import '../../domain/entities/warehouse_list_response_entity.dart';

class OwnerWarehouseRepositoryImpl implements OwnerWarehouseRepository {
  final OwnerWarehouseRemoteDataSource remoteDataSource;

  OwnerWarehouseRepositoryImpl({required this.remoteDataSource});


  @override
  Future<Either<Failure, WarehouseEntity>> createWarehouse(
    CreateOwnerWarehouseParams params,
  ) async {
    try {
      final warehouse = await remoteDataSource.createWarehouse(params);
      return Right(warehouse);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      // For validation errors and API specific errors
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
  Future<Either<Failure, WarehouseEntity>> updateWarehouse(
    int id,
    UpdateOwnerWarehouseParams params,
  ) async {
    try {
      final warehouse = await remoteDataSource.updateWarehouse(id, params.toJson());
      return Right(warehouse);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      // For validation errors and API specific errors
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
  Future<Either<Failure, void>> deleteWarehouse(int id) async {
    try {
      await remoteDataSource.deleteWarehouse(id);
      return const Right(null);
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
  @override
  Future<Either<Failure, WarehouseEntity>> getWarehouseDetails(int id) async {
    try {
      final result = await remoteDataSource.getWarehouseDetails(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WarehouseListResponseEntity>> getWarehouses() async {
    try {
      final response = await remoteDataSource.getWarehouses();
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure(
        e.response?.data['message'] ?? e.message ?? 'Unknown error occurred',
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

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

  @override
  Future<Either<Failure, WarehouseItemUpdateResultEntity>> updateWarehouseItem(
      UpdateWarehouseItemParams params) async {
    try {
      final paramsModel = UpdateWarehouseItemParamsModel(
        id: params.id,
        minQuantity: params.minQuantity,
        sellingPrice: params.sellingPrice,
        description: params.description,
      );
      final result = await remoteDataSource.updateWarehouseItem(paramsModel);
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
  Future<Either<Failure, void>> deleteWarehouseItem(int id) async {
    try {
      await remoteDataSource.deleteWarehouseItem(id);
      return const Right(null);
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
