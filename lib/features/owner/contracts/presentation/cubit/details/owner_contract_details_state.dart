import 'package:equatable/equatable.dart';
import '../../../domain/entities/contract_details_entity.dart';

abstract class OwnerContractDetailsState extends Equatable {
  const OwnerContractDetailsState();

  @override
  List<Object?> get props => [];
}

class OwnerContractDetailsInitial extends OwnerContractDetailsState {
  const OwnerContractDetailsInitial();
}

class OwnerContractDetailsLoading extends OwnerContractDetailsState {
  const OwnerContractDetailsLoading();
}

class OwnerContractDetailsLoaded extends OwnerContractDetailsState {
  final ContractDetailsEntity contract;

  const OwnerContractDetailsLoaded(this.contract);

  @override
  List<Object?> get props => [contract];
}

class OwnerContractDetailsError extends OwnerContractDetailsState {
  final String message;
  final bool isRetrying;

  const OwnerContractDetailsError(this.message, {this.isRetrying = false});

  @override
  List<Object?> get props => [message, isRetrying];
}
