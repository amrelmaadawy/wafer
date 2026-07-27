import '../../domain/entities/maintenance_requests_summary_entity.dart';

class MaintenanceRequestsSummaryModel extends MaintenanceRequestsSummaryEntity {
  const MaintenanceRequestsSummaryModel({
    required super.total,
    required super.open,
    required super.inProgress,
    required super.completed,
  });

  factory MaintenanceRequestsSummaryModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequestsSummaryModel(
      total: json['total'] ?? 0,
      open: json['open'] ?? 0,
      inProgress: json['in_progress'] ?? 0,
      completed: json['completed'] ?? 0,
    );
  }
}
