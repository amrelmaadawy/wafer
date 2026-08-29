import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/warehouse_items_response_entity.dart';
import '../entities/warehouse_summary_entity.dart';
import '../entities/create_warehouse_item_params.dart';
import '../entities/warehouse_item_entity.dart' hide WarehouseEntity;
import '../entities/update_warehouse_item_params.dart';
import '../entities/warehouse_item_update_result_entity.dart';
import '../entities/warehouse_item_details_entity.dart';

import '../entities/warehouse_list_response_entity.dart';
import '../entities/create_owner_warehouse_params.dart';
import '../entities/update_owner_warehouse_params.dart';
import '../entities/warehouse_entity.dart';
abstract class OwnerWarehouseRepository {
  Future<Either<Failure, WarehouseListResponseEntity>> getWarehouses();
  Future<Either<Failure, WarehouseEntity>> getWarehouseDetails(int id);
  Future<Either<Failure, WarehouseSummaryEntity>> getWarehouseSummary();
  Future<Either<Failure, WarehouseItemsResponseEntity>> getWarehouseItems({
    int page = 1,
    String? search,
    String? category,
    int? warehouseId,
    String? status,
  });
  Future<Either<Failure, WarehouseItemEntity>> createWarehouseItem(
    CreateWarehouseItemParams params,
  );
  Future<Either<Failure, WarehouseItemDetailsEntity>> getWarehouseItemDetails(
    int id,
  );
  Future<Either<Failure, WarehouseItemUpdateResultEntity>> updateWarehouseItem(
    UpdateWarehouseItemParams params,
  );
  Future<Either<Failure, void>> deleteWarehouseItem(int id);
  
  Future<Either<Failure, WarehouseEntity>> createWarehouse(
    CreateOwnerWarehouseParams params,
  );
  Future<Either<Failure, WarehouseEntity>> updateWarehouse(
    int id,
    UpdateOwnerWarehouseParams params,
  );
  Future<Either<Failure, void>> deleteWarehouse(int id);
}
