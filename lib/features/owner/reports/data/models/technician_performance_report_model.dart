import '../../domain/entities/maintenance_requests_report_entity.dart' show PaginationEntity;
import '../../domain/entities/technician_performance_report_entity.dart';
import 'technician_performance_item_model.dart';
import 'technician_performance_summary_model.dart';

class TechnicianPerformanceReportModel extends TechnicianPerformanceReportEntity {
  const TechnicianPerformanceReportModel({
    required super.summary,
    required super.items,
    required super.pagination,
  });

  factory TechnicianPerformanceReportModel.fromJson(Map<String, dynamic> json) {
    return TechnicianPerformanceReportModel(
      summary: TechnicianPerformanceSummaryModel.fromJson(json['summary'] ?? {}),
      items: (json['items'] as List?)
              ?.map((item) => TechnicianPerformanceItemModel.fromJson(item))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class PaginationModel extends PaginationEntity {
  const PaginationModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 15,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}
