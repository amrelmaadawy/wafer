import '../../domain/entities/technician_performance_summary_entity.dart';

class TechnicianPerformanceSummaryModel extends TechnicianPerformanceSummaryEntity {
  const TechnicianPerformanceSummaryModel({
    required super.totalTechnicians,
    required super.totalCompleted,
    required super.totalPending,
  });

  factory TechnicianPerformanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return TechnicianPerformanceSummaryModel(
      totalTechnicians: json['total_technicians'] ?? 0,
      totalCompleted: json['total_completed'] ?? 0,
      totalPending: json['total_pending'] ?? 0,
    );
  }
}
