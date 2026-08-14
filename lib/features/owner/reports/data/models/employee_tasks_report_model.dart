import '../../domain/entities/maintenance_requests_report_entity.dart'
    show PaginationEntity;
import '../../domain/entities/employee_tasks_report_entity.dart';
import 'employee_tasks_item_model.dart';
import 'employee_tasks_summary_model.dart';
import 'report_model_parsing.dart';

class EmployeeTasksReportModel extends EmployeeTasksReportEntity {
  const EmployeeTasksReportModel({
    required super.summary,
    required super.items,
    required super.pagination,
  });

  factory EmployeeTasksReportModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'];
    final pagination = json['pagination'];
    return EmployeeTasksReportModel(
      summary: EmployeeTasksSummaryModel.fromJson(
        summary is Map<String, dynamic> ? summary : const {},
      ),
      items:
          (json['items'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(EmployeeTasksItemModel.fromJson)
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(
        pagination is Map<String, dynamic> ? pagination : const {},
      ),
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
      currentPage: reportNullableInt(json['current_page']) ?? 1,
      lastPage: reportNullableInt(json['last_page']) ?? 1,
      perPage: reportNullableInt(json['per_page']) ?? 15,
      total: reportInt(json['total']),
    );
  }
}
