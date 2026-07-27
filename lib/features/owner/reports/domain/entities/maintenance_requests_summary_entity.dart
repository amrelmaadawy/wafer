import 'package:equatable/equatable.dart';

class MaintenanceRequestsSummaryEntity extends Equatable {
  final int total;
  final int open;
  final int inProgress;
  final int completed;

  const MaintenanceRequestsSummaryEntity({
    required this.total,
    required this.open,
    required this.inProgress,
    required this.completed,
  });

  @override
  List<Object?> get props => [
        total,
        open,
        inProgress,
        completed,
      ];
}
