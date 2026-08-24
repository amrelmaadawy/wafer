import 'package:equatable/equatable.dart';
import '../../../domain/entities/warehouse_summary_entity.dart';

abstract class OwnerWarehouseSummaryState extends Equatable {
  const OwnerWarehouseSummaryState();

  @override
  List<Object?> get props => [];
}

class OwnerWarehouseSummaryInitial extends OwnerWarehouseSummaryState {}

class OwnerWarehouseSummaryLoading extends OwnerWarehouseSummaryState {}

class OwnerWarehouseSummarySuccess extends OwnerWarehouseSummaryState {
  final WarehouseSummaryEntity summary;

  const OwnerWarehouseSummarySuccess(this.summary);

  @override
  List<Object?> get props => [summary];
}

class OwnerWarehouseSummaryFailure extends OwnerWarehouseSummaryState {
  final String message;

  const OwnerWarehouseSummaryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
