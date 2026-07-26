import '../../domain/entities/occupancy_report_entity.dart';
import 'occupancy_property_model.dart';
import 'report_pagination_model.dart';

class OccupancyReportSummaryModel extends OccupancyReportSummaryEntity {
  const OccupancyReportSummaryModel({
    required super.totalProperties,
    required super.totalUnits,
    required super.rentedUnits,
    required super.overallOccupancy,
  });

  factory OccupancyReportSummaryModel.fromJson(Map<String, dynamic> json) {
    return OccupancyReportSummaryModel(
      totalProperties: (json['total_properties'] as num?)?.toInt() ?? 0,
      totalUnits: (json['total_units'] as num?)?.toInt() ?? 0,
      rentedUnits: (json['rented_units'] as num?)?.toInt() ?? 0,
      overallOccupancy: (json['overall_occupancy'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class OccupancyReportModel extends OccupancyReportEntity {
  const OccupancyReportModel({
    required super.summary,
    required super.items,
    required super.pagination,
  });

  factory OccupancyReportModel.fromJson(Map<String, dynamic> json) {
    return OccupancyReportModel(
      summary: OccupancyReportSummaryModel.fromJson(json['summary'] ?? {}),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OccupancyPropertyModel.fromJson(e))
              .toList() ??
          [],
      pagination: ReportPaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}
