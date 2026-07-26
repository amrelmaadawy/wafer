import 'package:equatable/equatable.dart';
import '../../domain/entities/occupancy_report_entity.dart';

abstract class OwnerOccupancyState extends Equatable {
  const OwnerOccupancyState();

  @override
  List<Object?> get props => [];
}

class OwnerOccupancyInitial extends OwnerOccupancyState {
  const OwnerOccupancyInitial();
}

class OwnerOccupancyLoading extends OwnerOccupancyState {
  const OwnerOccupancyLoading();
}

class OwnerOccupancyLoaded extends OwnerOccupancyState {
  final OccupancyReportEntity report;
  final bool hasReachedMax;

  const OwnerOccupancyLoaded({
    required this.report,
    this.hasReachedMax = false,
  });

  OwnerOccupancyLoaded copyWith({
    OccupancyReportEntity? report,
    bool? hasReachedMax,
  }) {
    return OwnerOccupancyLoaded(
      report: report ?? this.report,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [report, hasReachedMax];
}

class OwnerOccupancyEmpty extends OwnerOccupancyState {
  const OwnerOccupancyEmpty();
}

class OwnerOccupancyError extends OwnerOccupancyState {
  final String message;

  const OwnerOccupancyError(this.message);

  @override
  List<Object?> get props => [message];
}
