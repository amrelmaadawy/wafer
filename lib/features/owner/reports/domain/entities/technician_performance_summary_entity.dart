import 'package:equatable/equatable.dart';

class TechnicianPerformanceSummaryEntity extends Equatable {
  final int totalTechnicians;
  final int totalCompleted;
  final int totalPending;

  const TechnicianPerformanceSummaryEntity({
    required this.totalTechnicians,
    required this.totalCompleted,
    required this.totalPending,
  });

  @override
  List<Object?> get props => [totalTechnicians, totalCompleted, totalPending];
}
