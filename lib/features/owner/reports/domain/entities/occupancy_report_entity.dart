import 'package:equatable/equatable.dart';
import 'occupancy_property_entity.dart';
import 'report_pagination_entity.dart';

class OccupancyReportSummaryEntity extends Equatable {
  final int totalProperties;
  final int totalUnits;
  final int rentedUnits;
  final double overallOccupancy;

  const OccupancyReportSummaryEntity({
    required this.totalProperties,
    required this.totalUnits,
    required this.rentedUnits,
    required this.overallOccupancy,
  });

  @override
  List<Object?> get props => [
        totalProperties,
        totalUnits,
        rentedUnits,
        overallOccupancy,
      ];
}

class OccupancyReportEntity extends Equatable {
  final OccupancyReportSummaryEntity summary;
  final List<OccupancyPropertyEntity> items;
  final ReportPaginationEntity pagination;

  const OccupancyReportEntity({
    required this.summary,
    required this.items,
    required this.pagination,
  });

  @override
  List<Object?> get props => [summary, items, pagination];
}
