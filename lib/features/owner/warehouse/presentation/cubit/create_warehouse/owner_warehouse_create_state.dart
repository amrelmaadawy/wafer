import 'package:equatable/equatable.dart';

import '../../../domain/entities/warehouse_entity.dart';

abstract class OwnerWarehouseCreateState extends Equatable {
  const OwnerWarehouseCreateState();

  @override
  List<Object> get props => [];
}

class OwnerWarehouseCreateInitial extends OwnerWarehouseCreateState {}

class OwnerWarehouseCreateLoading extends OwnerWarehouseCreateState {}

class OwnerWarehouseCreateSuccess extends OwnerWarehouseCreateState {
  final WarehouseEntity warehouse;

  const OwnerWarehouseCreateSuccess(this.warehouse);

  @override
  List<Object> get props => [warehouse];
}

class OwnerWarehouseCreateError extends OwnerWarehouseCreateState {
  final String message;

  const OwnerWarehouseCreateError(this.message);

  @override
  List<Object> get props => [message];
}
