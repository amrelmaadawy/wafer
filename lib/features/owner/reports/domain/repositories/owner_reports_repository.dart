import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/defaulter_entity.dart';
import '../entities/occupancy_property_entity.dart';
import '../entities/revenue_report_entity.dart';

abstract class OwnerReportsRepository {
  Future<Either<Failure, RevenueReportEntity>> getRevenueReport({
    bool forceRefresh = false,
    int? propertyId,
    String? startDate,
    String? endDate,
  });

  Future<Either<Failure, List<OccupancyPropertyEntity>>> getOccupancyReport({
    bool forceRefresh = false,
  });

  Future<Either<Failure, List<DefaulterEntity>>> getDefaultersReport({
    bool forceRefresh = false,
  });
}
