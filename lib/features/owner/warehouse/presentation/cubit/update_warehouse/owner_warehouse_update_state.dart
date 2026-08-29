import 'package:equatable/equatable.dart';

abstract class OwnerWarehouseUpdateState extends Equatable {
  const OwnerWarehouseUpdateState();

  @override
  List<Object> get props => [];
}

class OwnerWarehouseUpdateInitial extends OwnerWarehouseUpdateState {}

class OwnerWarehouseUpdateLoading extends OwnerWarehouseUpdateState {}

class OwnerWarehouseUpdateSuccess extends OwnerWarehouseUpdateState {}

class OwnerWarehouseUpdateError extends OwnerWarehouseUpdateState {
  final String message;

  const OwnerWarehouseUpdateError(this.message);

  @override
  List<Object> get props => [message];
}
