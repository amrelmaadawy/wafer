import '../../domain/entities/technician_stats_entity.dart';

class TechnicianStatsModel extends TechnicianStatsEntity {
  const TechnicianStatsModel({
    required super.ownerAssignmentsCount,
    required super.activeOwnerAssignmentsCount,
  });

  factory TechnicianStatsModel.fromJson(Map<String, dynamic> json) {
    return TechnicianStatsModel(
      ownerAssignmentsCount: json['owner_assignments_count'] ?? 0,
      activeOwnerAssignmentsCount: json['active_owner_assignments_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'owner_assignments_count': ownerAssignmentsCount,
      'active_owner_assignments_count': activeOwnerAssignmentsCount,
    };
  }
}
