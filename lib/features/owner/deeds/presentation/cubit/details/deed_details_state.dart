import 'package:equatable/equatable.dart';
import '../../../domain/entities/deed_entity.dart';

abstract class DeedDetailsState extends Equatable {
  const DeedDetailsState();

  @override
  List<Object?> get props => [];
}

class DeedDetailsInitial extends DeedDetailsState {
  const DeedDetailsInitial();
}

class DeedDetailsLoading extends DeedDetailsState {
  const DeedDetailsLoading();
}

class DeedDetailsLoaded extends DeedDetailsState {
  final DeedEntity deed;

  const DeedDetailsLoaded(this.deed);

  @override
  List<Object?> get props => [deed];
}

class DeedDetailsError extends DeedDetailsState {
  final String message;

  const DeedDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
