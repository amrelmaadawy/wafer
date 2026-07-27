import 'package:equatable/equatable.dart';
import 'maintenance_requests_item_entity.dart';
import 'maintenance_requests_summary_entity.dart';

class MaintenanceRequestsReportEntity extends Equatable {
  final MaintenanceRequestsSummaryEntity summary;
  final List<MaintenanceRequestsItemEntity> items;
  final PaginationEntity pagination;

  const MaintenanceRequestsReportEntity({
    required this.summary,
    required this.items,
    required this.pagination,
  });

  @override
  List<Object?> get props => [summary, items, pagination];
}

class PaginationEntity extends Equatable {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PaginationEntity({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];
}
