import 'package:equatable/equatable.dart';
import '../../domain/entities/finance_overview_entity.dart';

abstract class FinanceOverviewState extends Equatable {
  const FinanceOverviewState();

  @override
  List<Object?> get props => [];
}

class FinanceOverviewInitial extends FinanceOverviewState {}

class FinanceOverviewLoading extends FinanceOverviewState {}

class FinanceOverviewLoaded extends FinanceOverviewState {
  final FinanceOverviewEntity overview;

  const FinanceOverviewLoaded({required this.overview});

  @override
  List<Object?> get props => [overview];
}

class FinanceOverviewError extends FinanceOverviewState {
  final String message;

  const FinanceOverviewError({required this.message});

  @override
  List<Object?> get props => [message];
}
