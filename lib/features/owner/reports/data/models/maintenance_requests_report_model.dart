import '../../domain/entities/maintenance_requests_report_entity.dart';
import 'maintenance_requests_item_model.dart';
import 'maintenance_requests_summary_model.dart';

class MaintenanceRequestsReportModel extends MaintenanceRequestsReportEntity {
  const MaintenanceRequestsReportModel({
    required super.summary,
    required super.items,
    required super.pagination,
  });

  factory MaintenanceRequestsReportModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequestsReportModel(
      summary: MaintenanceRequestsSummaryModel.fromJson(json['summary'] ?? {}),
      items:
          (json['items'] as List?)
              ?.map((item) => MaintenanceRequestsItemModel.fromJson(item))
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
