import '../../domain/entities/activity_logs_report_entity.dart';
import 'activity_logs_summary_model.dart';
import 'activity_logs_item_model.dart';
import 'report_pagination_model.dart';
import 'report_model_parsing.dart';

class ActivityLogsReportModel extends ActivityLogsReportEntity {
  const ActivityLogsReportModel({
    required super.summary,
    required super.items,
    required super.pagination,
    required super.types,
    required super.actions,
  });

  factory ActivityLogsReportModel.fromJson(Map<String, dynamic> json) {
    final filters = reportMap(json['filter_options']);
    return ActivityLogsReportModel(
      summary: ActivityLogsSummaryModel.fromJson(reportMap(json['summary'])),
      items: reportMaps(
        json['items'],
      ).map(ActivityLogsItemModel.fromJson).toList(),
      pagination: ReportPaginationModel.fromJson(reportMap(json['pagination'])),
      types: reportValues(
        filters['types'],
      ).map(reportString).where((value) => value.isNotEmpty).toList(),
      actions: reportValues(
        filters['actions'],
      ).map(reportString).where((value) => value.isNotEmpty).toList(),
    );
  }
}
