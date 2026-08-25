import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/warehouse_items_response_entity.dart';
import '../entities/warehouse_summary_entity.dart';
import '../entities/create_warehouse_item_params.dart';
import '../entities/warehouse_item_entity.dart';
import '../entities/update_warehouse_item_params.dart';
import '../entities/warehouse_item_update_result_entity.dart';
import '../entities/warehouse_item_details_entity.dart';

abstract class OwnerWarehouseRepository {
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
}
