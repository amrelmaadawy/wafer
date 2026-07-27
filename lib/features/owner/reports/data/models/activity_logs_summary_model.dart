import '../../domain/entities/activity_logs_summary_entity.dart';

class ActivityLogsSummaryModel extends ActivityLogsSummaryEntity {
  const ActivityLogsSummaryModel({
    required super.totalLogs,
    required super.creates,
    required super.updates,
    required super.deletes,
  });

  factory ActivityLogsSummaryModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogsSummaryModel(
      totalLogs: json['total_logs'] ?? 0,
      creates: json['creates'] ?? 0,
      updates: json['updates'] ?? 0,
      deletes: json['deletes'] ?? 0,
    );
  }
}
