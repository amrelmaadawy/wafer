import 'package:equatable/equatable.dart';

import '../../../domain/entities/warehouse_item_entity.dart';

abstract class OwnerWarehouseItemCreateState extends Equatable {
  const OwnerWarehouseItemCreateState();

  @override
  List<Object> get props => [];
}

class OwnerWarehouseItemCreateInitial extends OwnerWarehouseItemCreateState {}

class OwnerWarehouseItemCreateLoading extends OwnerWarehouseItemCreateState {}

class OwnerWarehouseItemCreateSuccess extends OwnerWarehouseItemCreateState {
  final WarehouseItemEntity item;

  const OwnerWarehouseItemCreateSuccess(this.item);

  @override
  List<Object> get props => [item];
}

class OwnerWarehouseItemCreateError extends OwnerWarehouseItemCreateState {
  final String message;

  const OwnerWarehouseItemCreateError(this.message);

  @override
  List<Object> get props => [message];
}
