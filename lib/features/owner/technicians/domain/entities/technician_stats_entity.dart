import 'package:equatable/equatable.dart';

class TechnicianStatsEntity extends Equatable {
  final int ownerAssignmentsCount;
  final int activeOwnerAssignmentsCount;

  const TechnicianStatsEntity({
    required this.ownerAssignmentsCount,
    required this.activeOwnerAssignmentsCount,
  });

  @override
  List<Object?> get props => [
    ownerAssignmentsCount,
    activeOwnerAssignmentsCount,
  ];
}
