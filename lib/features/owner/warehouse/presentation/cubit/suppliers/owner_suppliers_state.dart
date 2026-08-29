import 'package:equatable/equatable.dart';
import '../../../domain/entities/suppliers/supplier_entity.dart';

abstract class OwnerSuppliersState extends Equatable {
  const OwnerSuppliersState();

  @override
  List<Object?> get props => [];
}

class OwnerSuppliersInitial extends OwnerSuppliersState {}

class OwnerSuppliersLoading extends OwnerSuppliersState {}

class OwnerSuppliersPaginationLoading extends OwnerSuppliersState {
  final List<SupplierEntity> oldSuppliers;

  const OwnerSuppliersPaginationLoading(this.oldSuppliers);

  @override
  List<Object?> get props => [oldSuppliers];
}

class OwnerSuppliersLoaded extends OwnerSuppliersState {
  final List<SupplierEntity> suppliers;
  final bool hasReachedMax;
  final int currentPage;

  const OwnerSuppliersLoaded({
    required this.suppliers,
    required this.hasReachedMax,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [suppliers, hasReachedMax, currentPage];
}

class OwnerSuppliersError extends OwnerSuppliersState {
  final String message;

  const OwnerSuppliersError({required this.message});

  @override
  List<Object?> get props => [message];
}
