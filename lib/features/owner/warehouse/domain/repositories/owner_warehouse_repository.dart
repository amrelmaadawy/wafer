import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/warehouse_items_response_entity.dart';
import '../entities/warehouse_summary_entity.dart';

abstract class OwnerWarehouseRepository {
  Future<Either<Failure, WarehouseSummaryEntity>> getWarehouseSummary();
  Future<Either<Failure, WarehouseItemsResponseEntity>> getWarehouseItems({
    int page = 1,
    String? search,
    String? category,
    int? warehouseId,
    String? status,
  });
}
