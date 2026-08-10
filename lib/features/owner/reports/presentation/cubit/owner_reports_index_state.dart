import 'package:equatable/equatable.dart';
import '../../domain/entities/owner_reports_index_entity.dart';

abstract class OwnerReportsIndexState extends Equatable {
  const OwnerReportsIndexState();

  @override
  List<Object?> get props => [];
}

class OwnerReportsIndexInitial extends OwnerReportsIndexState {}

class OwnerReportsIndexLoading extends OwnerReportsIndexState {}

class OwnerReportsIndexLoaded extends OwnerReportsIndexState {
  final OwnerReportsIndexEntity indexData;

  const OwnerReportsIndexLoaded({required this.indexData});

  @override
  List<Object?> get props => [indexData];
}

class OwnerReportsIndexError extends OwnerReportsIndexState {
  final String message;

  const OwnerReportsIndexError({required this.message});

  @override
  List<Object?> get props => [message];
}
