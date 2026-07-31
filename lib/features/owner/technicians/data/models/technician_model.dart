import '../../domain/entities/technician_entity.dart';
import 'technician_assignment_model.dart';
import 'technician_stats_model.dart';

class TechnicianModel extends TechnicianEntity {
  const TechnicianModel({
    required super.id,
    super.ownerId,
    required super.name,
    super.phone,
    super.specialty,
    super.companyName,
    required super.isActive,
    super.notes,
    required super.stats,
    required super.assignments,
    super.createdAt,
    super.updatedAt,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) {
    return TechnicianModel(
      id: json['id'] as int,
      ownerId: json['owner_id'] as int?,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String?,
      specialty: json['specialty'] as String?,
      companyName: json['company_name'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      notes: json['notes'] as String?,
      stats: TechnicianStatsModel.fromJson(
          json['stats'] as Map<String, dynamic>? ?? {}),
      assignments: (json['assignments'] as List<dynamic>?)
              ?.map((e) => TechnicianAssignmentModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'phone': phone,
      'specialty': specialty,
      'company_name': companyName,
      'is_active': isActive,
      'notes': notes,
      'stats': (stats as TechnicianStatsModel).toJson(),
      'assignments': assignments
          .map((e) => (e as TechnicianAssignmentModel).toJson())
          .toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
