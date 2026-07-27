import 'package:equatable/equatable.dart';
import 'maintenance_requests_report_entity.dart' show PaginationEntity;
import 'technician_performance_item_entity.dart';
import 'technician_performance_summary_entity.dart';

class TechnicianPerformanceReportEntity extends Equatable {
  final TechnicianPerformanceSummaryEntity summary;
  final List<TechnicianPerformanceItemEntity> items;
  final PaginationEntity pagination;

  const TechnicianPerformanceReportEntity({
    required this.summary,
    required this.items,
    required this.pagination,
  });

  @override
  List<Object?> get props => [summary, items, pagination];
}
