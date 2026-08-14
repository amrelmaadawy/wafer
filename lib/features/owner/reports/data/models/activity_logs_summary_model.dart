import '../../domain/entities/activity_logs_summary_entity.dart';
import 'report_model_parsing.dart';

class ActivityLogsSummaryModel extends ActivityLogsSummaryEntity {
  const ActivityLogsSummaryModel({
    required super.totalLogs,
    required super.creates,
    required super.updates,
    required super.deletes,
  });

  factory ActivityLogsSummaryModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogsSummaryModel(
      totalLogs: reportInt(json['total_logs']),
      creates: reportInt(json['creates']),
      updates: reportInt(json['updates']),
      deletes: reportInt(json['deletes']),
    );
  }
}
