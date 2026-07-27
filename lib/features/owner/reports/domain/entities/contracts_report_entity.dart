import 'package:equatable/equatable.dart';
import '../../data/models/report_pagination_model.dart';
import 'contracts_report_item_entity.dart';
import 'contracts_report_summary_entity.dart';

class ContractsReportEntity extends Equatable {
  final ContractsReportSummaryEntity summary;
  final List<ContractsReportItemEntity> items;
  final ReportPaginationModel pagination;

  const ContractsReportEntity({
    required this.summary,
    required this.items,
    required this.pagination,
  });

  @override
  List<Object?> get props => [
        summary,
        items,
        pagination,
      ];

  ContractsReportEntity copyWith({
    ContractsReportSummaryEntity? summary,
    List<ContractsReportItemEntity>? items,
    ReportPaginationModel? pagination,
  }) {
    return ContractsReportEntity(
      summary: summary ?? this.summary,
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
    );
  }
}
