import 'package:equatable/equatable.dart';
import 'report_pagination_entity.dart';
import 'units_status_filter_options_entity.dart';
import 'units_status_item_entity.dart';
import 'units_status_summary_entity.dart';

class UnitsStatusReportEntity extends Equatable {
  final UnitsStatusSummaryEntity summary;
  final List<UnitsStatusItemEntity> items;
  final ReportPaginationEntity pagination;
  final UnitsStatusFilterOptionsEntity filterOptions;

  const UnitsStatusReportEntity({
    required this.summary,
    required this.items,
    required this.pagination,
    required this.filterOptions,
  });

  @override
  List<Object?> get props => [summary, items, pagination, filterOptions];
}
