import 'package:equatable/equatable.dart';

import '../../../domain/entities/warehouse_item_details_entity.dart';

abstract class OwnerWarehouseItemDetailsState extends Equatable {
  const OwnerWarehouseItemDetailsState();

  @override
  List<Object?> get props => [];
}

class OwnerWarehouseItemDetailsInitial extends OwnerWarehouseItemDetailsState {}

class OwnerWarehouseItemDetailsLoading extends OwnerWarehouseItemDetailsState {}

class OwnerWarehouseItemDetailsLoaded extends OwnerWarehouseItemDetailsState {
  final WarehouseItemDetailsEntity details;

  const OwnerWarehouseItemDetailsLoaded(this.details);

  @override
  List<Object?> get props => [details];
}

class OwnerWarehouseItemDetailsError extends OwnerWarehouseItemDetailsState {
  final String message;

  const OwnerWarehouseItemDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
