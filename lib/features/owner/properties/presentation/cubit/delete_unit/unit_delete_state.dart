import 'package:equatable/equatable.dart';

abstract class UnitDeleteState extends Equatable {
  const UnitDeleteState();

  @override
  List<Object> get props => [];
}

class UnitDeleteInitial extends UnitDeleteState {}

class UnitDeleteLoading extends UnitDeleteState {}

class UnitDeleteSuccess extends UnitDeleteState {}

class UnitDeleteError extends UnitDeleteState {
  final String message;

  const UnitDeleteError(this.message);

  @override
  List<Object> get props => [message];
}
