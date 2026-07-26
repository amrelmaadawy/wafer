import 'package:equatable/equatable.dart';
import '../../domain/entities/revenue_report_entity.dart';

abstract class OwnerRevenueState extends Equatable {
  const OwnerRevenueState();

  @override
  List<Object?> get props => [];
}

class OwnerRevenueInitial extends OwnerRevenueState {
  const OwnerRevenueInitial();
}

class OwnerRevenueLoading extends OwnerRevenueState {
  const OwnerRevenueLoading();
}

class OwnerRevenueLoaded extends OwnerRevenueState {
  final RevenueReportEntity report;

  const OwnerRevenueLoaded({
    required this.report,
  });

  @override
  List<Object?> get props => [report];
}

class OwnerRevenueEmpty extends OwnerRevenueState {
  const OwnerRevenueEmpty();
}

class OwnerRevenueError extends OwnerRevenueState {
  final String message;

  const OwnerRevenueError(this.message);

  @override
  List<Object?> get props => [message];
}
