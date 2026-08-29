import 'package:equatable/equatable.dart';

import '../../../../domain/entities/suppliers/supplier_entity.dart';

abstract class OwnerSupplierUpdateState extends Equatable {
  const OwnerSupplierUpdateState();

  @override
  List<Object?> get props => [];
}

class OwnerSupplierUpdateInitial extends OwnerSupplierUpdateState {}

class OwnerSupplierUpdateLoading extends OwnerSupplierUpdateState {}

class OwnerSupplierUpdateSuccess extends OwnerSupplierUpdateState {
  final SupplierEntity supplier;
  const OwnerSupplierUpdateSuccess(this.supplier);

  @override
  List<Object?> get props => [supplier];
}

class OwnerSupplierUpdateError extends OwnerSupplierUpdateState {
  final String message;
  final Map<String, dynamic>? validationErrors;

  const OwnerSupplierUpdateError(this.message, {this.validationErrors});

  @override
  List<Object?> get props => [message, validationErrors];
}
