import 'package:equatable/equatable.dart';

import '../../../domain/entities/warehouse_list_response_entity.dart';

abstract class OwnerWarehousesState extends Equatable {
  const OwnerWarehousesState();

  @override
  List<Object> get props => [];
}

class OwnerWarehousesInitial extends OwnerWarehousesState {}

class OwnerWarehousesLoading extends OwnerWarehousesState {}

class OwnerWarehousesLoaded extends OwnerWarehousesState {
  final WarehouseListResponseEntity response;

  const OwnerWarehousesLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class OwnerWarehousesError extends OwnerWarehousesState {
  final String message;

  const OwnerWarehousesError({required this.message});

  @override
  List<Object> get props => [message];
}
