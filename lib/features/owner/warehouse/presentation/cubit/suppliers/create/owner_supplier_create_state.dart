import 'package:equatable/equatable.dart';

abstract class OwnerSupplierCreateState extends Equatable {
  const OwnerSupplierCreateState();

  @override
  List<Object?> get props => [];
}

class OwnerSupplierCreateInitial extends OwnerSupplierCreateState {}

class OwnerSupplierCreateLoading extends OwnerSupplierCreateState {}

class OwnerSupplierCreateSuccess extends OwnerSupplierCreateState {}

class OwnerSupplierCreateError extends OwnerSupplierCreateState {
  final String message;
  final Map<String, dynamic>? validationErrors;

  const OwnerSupplierCreateError(this.message, {this.validationErrors});

  @override
  List<Object?> get props => [message, validationErrors];
}
