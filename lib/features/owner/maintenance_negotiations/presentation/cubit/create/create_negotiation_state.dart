import 'package:equatable/equatable.dart';

abstract class CreateNegotiationState extends Equatable {
  const CreateNegotiationState();

  @override
  List<Object?> get props => [];
}

class CreateNegotiationInitial extends CreateNegotiationState {}

class CreateNegotiationLoading extends CreateNegotiationState {}

class CreateNegotiationSuccess extends CreateNegotiationState {}

class CreateNegotiationFailure extends CreateNegotiationState {
  final String errorMessage;

  const CreateNegotiationFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
