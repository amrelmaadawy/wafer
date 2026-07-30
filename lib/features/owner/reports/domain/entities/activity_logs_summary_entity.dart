import 'package:equatable/equatable.dart';

class ActivityLogsSummaryEntity extends Equatable {
  final int totalLogs;
  final int creates;
  final int updates;
  final int deletes;

  const ActivityLogsSummaryEntity({
    required this.totalLogs,
    required this.creates,
    required this.updates,
    required this.deletes,
  });

  @override
  List<Object?> get props => [totalLogs, creates, updates, deletes];
}
