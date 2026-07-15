import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/defaulter_entity.dart';
import '../entities/occupancy_property_entity.dart';
import '../entities/revenue_entry_entity.dart';

abstract class OwnerReportsRepository {
  Future<Either<Failure, List<RevenueEntryEntity>>> getRevenueReport({
    bool forceRefresh = false,
  });

  Future<Either<Failure, List<OccupancyPropertyEntity>>> getOccupancyReport({
    bool forceRefresh = false,
  });

  Future<Either<Failure, List<DefaulterEntity>>> getDefaultersReport({
    bool forceRefresh = false,
  });
}
