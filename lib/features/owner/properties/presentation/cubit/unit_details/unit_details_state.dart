import 'package:equatable/equatable.dart';
import '../../../domain/entities/unit_full_details_entity.dart';

abstract class UnitDetailsState extends Equatable {
  const UnitDetailsState();

  @override
  List<Object> get props => [];
}

class UnitDetailsInitial extends UnitDetailsState {}

class UnitDetailsLoading extends UnitDetailsState {}

class UnitDetailsLoaded extends UnitDetailsState {
  final UnitFullDetailsEntity unit;

  const UnitDetailsLoaded(this.unit);

  @override
  List<Object> get props => [unit];
}

class UnitDetailsError extends UnitDetailsState {
  final String message;

  const UnitDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
