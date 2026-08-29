import 'package:equatable/equatable.dart';
import '../../domain/entities/warehouse_entity.dart';

abstract class OwnerWarehouseDetailsState extends Equatable {
  const OwnerWarehouseDetailsState();

  @override
  List<Object?> get props => [];
}

class OwnerWarehouseDetailsInitial extends OwnerWarehouseDetailsState {}

class OwnerWarehouseDetailsLoading extends OwnerWarehouseDetailsState {}

class OwnerWarehouseDetailsLoaded extends OwnerWarehouseDetailsState {
  final WarehouseEntity warehouse;

  const OwnerWarehouseDetailsLoaded(this.warehouse);

  @override
  List<Object?> get props => [warehouse];
}

class OwnerWarehouseDetailsError extends OwnerWarehouseDetailsState {
  final String message;

  const OwnerWarehouseDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
