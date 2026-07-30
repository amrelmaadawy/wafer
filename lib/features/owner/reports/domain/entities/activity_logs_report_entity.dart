import 'package:equatable/equatable.dart';
import 'report_pagination_entity.dart';
import 'activity_logs_summary_entity.dart';
import 'activity_logs_item_entity.dart';

class ActivityLogsReportEntity extends Equatable {
  final ActivityLogsSummaryEntity summary;
  final List<ActivityLogsItemEntity> items;
  final ReportPaginationEntity pagination;
  final List<String> types;
  final List<String> actions;

  const ActivityLogsReportEntity({
    required this.summary,
    required this.items,
    required this.pagination,
    required this.types,
    required this.actions,
  });

  @override
  List<Object?> get props => [summary, items, pagination, types, actions];
}
