import 'package:equatable/equatable.dart';
import '../../../../domain/entities/suppliers/supplier_entity.dart';

abstract class OwnerSupplierDetailsState extends Equatable {
  const OwnerSupplierDetailsState();

  @override
  List<Object?> get props => [];
}

class OwnerSupplierDetailsInitial extends OwnerSupplierDetailsState {}

class OwnerSupplierDetailsLoading extends OwnerSupplierDetailsState {}

class OwnerSupplierDetailsSuccess extends OwnerSupplierDetailsState {
  final SupplierEntity supplier;

  const OwnerSupplierDetailsSuccess(this.supplier);

  @override
  List<Object?> get props => [supplier];
}

class OwnerSupplierDetailsError extends OwnerSupplierDetailsState {
  final String message;

  const OwnerSupplierDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
