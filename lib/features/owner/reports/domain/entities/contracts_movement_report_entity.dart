import 'package:equatable/equatable.dart';
import 'contracts_movement_summary_entity.dart';
import 'contracts_movement_item_entity.dart';

class ContractsMovementReportEntity extends Equatable {
  final ContractsMovementSummaryEntity summary;
  final List<ContractsMovementItemEntity> items;
  final PaginationEntity pagination;

  const ContractsMovementReportEntity({
    required this.summary,
    required this.items,
    required this.pagination,
  });

  @override
  List<Object?> get props => [summary, items, pagination];

  ContractsMovementReportEntity copyWith({
    ContractsMovementSummaryEntity? summary,
    List<ContractsMovementItemEntity>? items,
    PaginationEntity? pagination,
  }) {
    return ContractsMovementReportEntity(
      summary: summary ?? this.summary,
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
    );
  }
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
