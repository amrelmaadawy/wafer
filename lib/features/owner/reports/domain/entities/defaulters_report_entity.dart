import 'package:equatable/equatable.dart';
import '../../data/models/report_pagination_model.dart';
import 'defaulters_report_item_entity.dart';
import 'defaulters_report_summary_entity.dart';

class DefaultersReportEntity extends Equatable {
  final DefaultersReportSummaryEntity summary;
  final List<DefaultersReportItemEntity> items;
  final ReportPaginationModel pagination;

  const DefaultersReportEntity({
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

  DefaultersReportEntity copyWith({
    DefaultersReportSummaryEntity? summary,
    List<DefaultersReportItemEntity>? items,
    ReportPaginationModel? pagination,
  }) {
    return DefaultersReportEntity(
      summary: summary ?? this.summary,
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
    );
  }
}
