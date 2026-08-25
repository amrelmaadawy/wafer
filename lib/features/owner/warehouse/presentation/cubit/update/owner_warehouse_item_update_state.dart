import 'package:equatable/equatable.dart';

import '../../../domain/entities/warehouse_item_update_result_entity.dart';

abstract class OwnerWarehouseItemUpdateState extends Equatable {
  const OwnerWarehouseItemUpdateState();

  @override
  List<Object?> get props => [];
}

class OwnerWarehouseItemUpdateInitial extends OwnerWarehouseItemUpdateState {}

class OwnerWarehouseItemUpdateLoading extends OwnerWarehouseItemUpdateState {}

class OwnerWarehouseItemUpdateSuccess extends OwnerWarehouseItemUpdateState {
  final WarehouseItemUpdateResultEntity result;

  const OwnerWarehouseItemUpdateSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class OwnerWarehouseItemUpdateError extends OwnerWarehouseItemUpdateState {
  final String message;
  final Map<String, dynamic>? validationErrors;

  const OwnerWarehouseItemUpdateError(this.message, {this.validationErrors});

  @override
  List<Object?> get props => [message, validationErrors];
}
