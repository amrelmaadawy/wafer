import 'package:equatable/equatable.dart';
import '../../domain/entities/technician_performance_report_entity.dart';

abstract class OwnerTechnicianPerformanceState extends Equatable {
  const OwnerTechnicianPerformanceState();

  @override
  List<Object?> get props => [];
}

class OwnerTechnicianPerformanceInitial
    extends OwnerTechnicianPerformanceState {}

class OwnerTechnicianPerformanceLoading
    extends OwnerTechnicianPerformanceState {
  final bool isPagination;
  const OwnerTechnicianPerformanceLoading({this.isPagination = false});

  @override
  List<Object?> get props => [isPagination];
}

class OwnerTechnicianPerformanceLoaded extends OwnerTechnicianPerformanceState {
  final TechnicianPerformanceReportEntity report;
  final bool hasReachedMax;

  const OwnerTechnicianPerformanceLoaded(
    this.report, {
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [report, hasReachedMax];
}

class OwnerTechnicianPerformanceEmpty extends OwnerTechnicianPerformanceState {}

class OwnerTechnicianPerformanceError extends OwnerTechnicianPerformanceState {
  final String message;
  const OwnerTechnicianPerformanceError(this.message);

  @override
  List<Object?> get props => [message];
}
