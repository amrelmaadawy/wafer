import '../../domain/entities/report_pagination_entity.dart';
import 'report_model_parsing.dart';

class ReportPaginationModel extends ReportPaginationEntity {
  const ReportPaginationModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    required super.from,
    required super.to,
  });

  factory ReportPaginationModel.fromJson(Map<String, dynamic> json) {
    return ReportPaginationModel(
      currentPage: reportNullableInt(json['current_page']) ?? 1,
      lastPage: reportNullableInt(json['last_page']) ?? 1,
      perPage: reportNullableInt(json['per_page']) ?? 15,
      total: reportInt(json['total']),
      from: reportInt(json['from']),
      to: reportInt(json['to']),
    );
  }
}
