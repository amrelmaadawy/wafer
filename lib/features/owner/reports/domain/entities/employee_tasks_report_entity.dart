import 'package:equatable/equatable.dart';
import 'maintenance_requests_report_entity.dart' show PaginationEntity;
import 'employee_tasks_item_entity.dart';
import 'employee_tasks_summary_entity.dart';

class EmployeeTasksReportEntity extends Equatable {
  final EmployeeTasksSummaryEntity summary;
  final List<EmployeeTasksItemEntity> items;
  final PaginationEntity pagination;

  const EmployeeTasksReportEntity({
    required this.summary,
    required this.items,
    required this.pagination,
  });

  @override
  List<Object?> get props => [summary, items, pagination];
}
