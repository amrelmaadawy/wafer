import 'package:equatable/equatable.dart';

abstract class OwnerWarehouseDeleteState extends Equatable {
  const OwnerWarehouseDeleteState();

  @override
  List<Object> get props => [];
}

class OwnerWarehouseDeleteInitial extends OwnerWarehouseDeleteState {}

class OwnerWarehouseDeleteLoading extends OwnerWarehouseDeleteState {}

class OwnerWarehouseDeleteSuccess extends OwnerWarehouseDeleteState {}

class OwnerWarehouseDeleteError extends OwnerWarehouseDeleteState {
  final String message;

  const OwnerWarehouseDeleteError(this.message);

  @override
  List<Object> get props => [message];
}
