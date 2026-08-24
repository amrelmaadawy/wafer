import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/warehouse_summary_entity.dart';

abstract class OwnerWarehouseRepository {
  Future<Either<Failure, WarehouseSummaryEntity>> getWarehouseSummary();
}
