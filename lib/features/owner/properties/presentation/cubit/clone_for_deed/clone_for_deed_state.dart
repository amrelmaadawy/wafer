import 'package:equatable/equatable.dart';

abstract class CloneForDeedState extends Equatable {
  const CloneForDeedState();

  @override
  List<Object?> get props => [];
}

class CloneForDeedInitial extends CloneForDeedState {}

class CloneForDeedLoading extends CloneForDeedState {}

class CloneForDeedSuccess extends CloneForDeedState {
  final int newPropertyId;

  const CloneForDeedSuccess(this.newPropertyId);

  @override
  List<Object?> get props => [newPropertyId];
}

class CloneForDeedError extends CloneForDeedState {
  final String message;

  const CloneForDeedError(this.message);

  @override
  List<Object?> get props => [message];
}

