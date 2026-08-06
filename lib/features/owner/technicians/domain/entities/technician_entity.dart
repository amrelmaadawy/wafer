import 'package:equatable/equatable.dart';
import 'technician_stats_entity.dart';
import 'technician_assignment_entity.dart';

class TechnicianEntity extends Equatable {
  final int id;
  final int? ownerId;
  final String name;
  final String? phone;
  final String? specialty;
  final String? companyName;
  final bool isActive;
  final String? notes;
  final TechnicianStatsEntity stats;
  final List<TechnicianAssignmentEntity> assignments;
  final String? createdAt;
  final String? updatedAt;

  const TechnicianEntity({
    required this.id,
    this.ownerId,
    required this.name,
    this.phone,
    this.specialty,
    this.companyName,
    required this.isActive,
    this.notes,
    required this.stats,
    required this.assignments,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    ownerId,
    name,
    phone,
    specialty,
    companyName,
    isActive,
    notes,
    stats,
    assignments,
    createdAt,
    updatedAt,
  ];
}
