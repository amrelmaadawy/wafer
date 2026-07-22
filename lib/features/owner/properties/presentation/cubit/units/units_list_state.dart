import 'package:equatable/equatable.dart';
import '../../../domain/entities/unit_entity.dart';

abstract class UnitsListState extends Equatable {
  const UnitsListState();

  @override
  List<Object?> get props => [];
}

class UnitsListInitial extends UnitsListState {
  const UnitsListInitial();
}

class UnitsListLoading extends UnitsListState {
  const UnitsListLoading();
}

class UnitsListLoaded extends UnitsListState {
  final List<UnitEntity> units;

  const UnitsListLoaded(this.units);

  @override
  List<Object?> get props => [units];
}

class UnitsListEmpty extends UnitsListState {
  const UnitsListEmpty();
}

class UnitsListError extends UnitsListState {
  final String message;

  const UnitsListError(this.message);

  @override
  List<Object?> get props => [message];
}
