import 'package:equatable/equatable.dart';
import '../../domain/entities/defaulters_report_entity.dart';

abstract class OwnerDefaultersState extends Equatable {
  const OwnerDefaultersState();

  @override
  List<Object> get props => [];
}

class OwnerDefaultersInitial extends OwnerDefaultersState {}

class OwnerDefaultersLoading extends OwnerDefaultersState {}

class OwnerDefaultersLoaded extends OwnerDefaultersState {
  final DefaultersReportEntity report;
  final bool hasReachedMax;

  const OwnerDefaultersLoaded({
    required this.report,
    required this.hasReachedMax,
  });

  @override
  List<Object> get props => [report, hasReachedMax];

  OwnerDefaultersLoaded copyWith({
    DefaultersReportEntity? report,
    bool? hasReachedMax,
  }) {
    return OwnerDefaultersLoaded(
      report: report ?? this.report,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class OwnerDefaultersEmpty extends OwnerDefaultersState {}

class OwnerDefaultersError extends OwnerDefaultersState {
  final String message;

  const OwnerDefaultersError(this.message);

  @override
  List<Object> get props => [message];
}
