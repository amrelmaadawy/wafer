import 'package:equatable/equatable.dart';
import '../../data/models/report_pagination_model.dart';
import 'contracts_report_item_entity.dart';
import 'contracts_report_summary_entity.dart';

class ContractsReportEntity extends Equatable {
  final ContractsReportSummaryEntity summary;
  final List<ContractsReportItemEntity> items;
  final ReportPaginationModel pagination;
  final ContractsFilterOptionsEntity filterOptions;

  const ContractsReportEntity({
    required this.summary,
    required this.items,
    required this.pagination,
    required this.filterOptions,
  });

  @override
  List<Object?> get props => [summary, items, pagination, filterOptions];

  ContractsReportEntity copyWith({
    ContractsReportSummaryEntity? summary,
    List<ContractsReportItemEntity>? items,
    ReportPaginationModel? pagination,
    ContractsFilterOptionsEntity? filterOptions,
  }) {
    return ContractsReportEntity(
      summary: summary ?? this.summary,
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
      filterOptions: filterOptions ?? this.filterOptions,
    );
  }
}

class ContractsFilterOptionsEntity extends Equatable {
  final List<ContractsStatusFilterEntity> statuses;
  final List<ContractsPropertyFilterEntity> properties;

  const ContractsFilterOptionsEntity({
    required this.statuses,
    required this.properties,
  });

  @override
  List<Object?> get props => [statuses, properties];
}

class ContractsStatusFilterEntity extends Equatable {
  final String value;
  final String label;

  const ContractsStatusFilterEntity({required this.value, required this.label});

  @override
  List<Object?> get props => [value, label];
}

class ContractsPropertyFilterEntity extends Equatable {
  final int id;
  final String? name;
  final String code;

  const ContractsPropertyFilterEntity({
    required this.id,
    this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}
