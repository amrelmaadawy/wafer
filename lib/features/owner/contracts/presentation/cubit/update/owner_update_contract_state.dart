import 'package:equatable/equatable.dart';

abstract class OwnerUpdateContractState extends Equatable {
  const OwnerUpdateContractState();

  @override
  List<Object?> get props => [];
}

class OwnerUpdateContractInitial extends OwnerUpdateContractState {
  const OwnerUpdateContractInitial();
}

class OwnerUpdateContractLoading extends OwnerUpdateContractState {
  const OwnerUpdateContractLoading();
}

class OwnerUpdateContractSuccess extends OwnerUpdateContractState {
  const OwnerUpdateContractSuccess();
}

class OwnerUpdateContractError extends OwnerUpdateContractState {
  final String message;
  final Map<String, dynamic>? validationErrors;

  const OwnerUpdateContractError(this.message, {this.validationErrors});

  @override
  List<Object?> get props => [message, validationErrors];
}
