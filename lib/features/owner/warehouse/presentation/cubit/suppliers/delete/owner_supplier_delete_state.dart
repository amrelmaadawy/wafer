import 'package:equatable/equatable.dart';

abstract class OwnerSupplierDeleteState extends Equatable {
  const OwnerSupplierDeleteState();

  @override
  List<Object?> get props => [];
}

class OwnerSupplierDeleteInitial extends OwnerSupplierDeleteState {}

class OwnerSupplierDeleteLoading extends OwnerSupplierDeleteState {}

class OwnerSupplierDeleteSuccess extends OwnerSupplierDeleteState {}

class OwnerSupplierDeleteError extends OwnerSupplierDeleteState {
  final String message;

  const OwnerSupplierDeleteError(this.message);

  @override
  List<Object?> get props => [message];
}
