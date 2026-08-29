import 'package:equatable/equatable.dart';

abstract class DeleteOwnerWarehouseItemState extends Equatable {
  const DeleteOwnerWarehouseItemState();

  @override
  List<Object> get props => [];
}

class DeleteOwnerWarehouseItemInitial extends DeleteOwnerWarehouseItemState {}

class DeleteOwnerWarehouseItemLoading extends DeleteOwnerWarehouseItemState {}

class DeleteOwnerWarehouseItemSuccess extends DeleteOwnerWarehouseItemState {}

class DeleteOwnerWarehouseItemError extends DeleteOwnerWarehouseItemState {
  final String message;

  const DeleteOwnerWarehouseItemError(this.message);

  @override
  List<Object> get props => [message];
}
