import 'package:equatable/equatable.dart';
import '../../domain/entities/units_status_filter_options_entity.dart';
import '../../domain/entities/units_status_report_entity.dart';

abstract class OwnerUnitsStatusState extends Equatable {
  const OwnerUnitsStatusState();

  @override
  List<Object?> get props => [];
}

class OwnerUnitsStatusInitial extends OwnerUnitsStatusState {
  const OwnerUnitsStatusInitial();
}

class OwnerUnitsStatusLoading extends OwnerUnitsStatusState {
  const OwnerUnitsStatusLoading();
}

class OwnerUnitsStatusLoaded extends OwnerUnitsStatusState {
  final UnitsStatusReportEntity report;
  final bool hasReachedMax;

  const OwnerUnitsStatusLoaded({
    required this.report,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [report, hasReachedMax];
}

class OwnerUnitsStatusEmpty extends OwnerUnitsStatusState {
  final UnitsStatusFilterOptionsEntity filterOptions;

  const OwnerUnitsStatusEmpty({required this.filterOptions});

  @override
  List<Object?> get props => [filterOptions];
}

class OwnerUnitsStatusError extends OwnerUnitsStatusState {
  final String message;

  const OwnerUnitsStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
