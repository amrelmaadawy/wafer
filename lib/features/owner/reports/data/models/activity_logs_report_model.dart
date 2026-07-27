import '../../domain/entities/activity_logs_report_entity.dart';
import 'activity_logs_summary_model.dart';
import 'activity_logs_item_model.dart';
import 'report_pagination_model.dart';

class ActivityLogsReportModel extends ActivityLogsReportEntity {
  const ActivityLogsReportModel({
    required super.summary,
    required super.items,
    required super.pagination,
    required super.types,
    required super.actions,
  });

  factory ActivityLogsReportModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogsReportModel(
      summary: ActivityLogsSummaryModel.fromJson(json['summary'] ?? {}),
      items: (json['items'] as List?)
              ?.map((item) => ActivityLogsItemModel.fromJson(item))
              .toList() ??
          [],
      pagination: ReportPaginationModel.fromJson(json['pagination'] ?? {}),
      types: (json['filter_options']?['types'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      actions: (json['filter_options']?['actions'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
