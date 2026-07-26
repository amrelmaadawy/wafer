import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/defaulter_entity.dart';
import '../entities/occupancy_property_entity.dart';
import '../entities/revenue_report_entity.dart';
import '../entities/units_status_report_entity.dart';

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

  Future<Either<Failure, UnitsStatusReportEntity>> getUnitsStatusReport({
    bool forceRefresh = false,
    int page = 1,
    int? propertyId,
    String? status,
  });
}
